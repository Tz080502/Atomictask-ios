import Foundation
import Supabase

@MainActor
class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: Constants.supabaseURL)!,
            supabaseKey: Constants.supabaseAnonKey
        )
        
        _Concurrency.Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        do {
            let session = try await client.auth.session
            self.currentUser = session.user
            self.isAuthenticated = true
            print("🔐 AUTH DEBUG - Session restored for user:", session.user.id.uuidString)
            print("🔐 AUTH DEBUG - User email:", session.user.email ?? "no email")
        } catch {
            self.currentUser = nil
            self.isAuthenticated = false
            print("⚠️ AUTH DEBUG - No active session found")
        }
    }
    
    func signIn(email: String, password: String) async throws {
        print("🔐 AUTH DEBUG - Attempting sign in for:", email)
        let session = try await client.auth.signIn(email: email, password: password)
        self.currentUser = session.user
        self.isAuthenticated = true
        print("✅ AUTH DEBUG - Sign in successful, user ID:", session.user.id.uuidString)
        print("🔐 AUTH DEBUG - Access token:", session.accessToken.prefix(50) + "...")
    }
    
    func signUp(email: String, password: String) async throws {
        print("🔐 AUTH DEBUG - Attempting sign up for:", email)
        
        let response = try await client.auth.signUp(email: email, password: password)
        self.currentUser = response.user
        self.isAuthenticated = true
        print("✅ AUTH DEBUG - Sign up successful, user ID:", response.user.id.uuidString)
        if let token = response.session?.accessToken {
            print("🔐 AUTH DEBUG - Access token:", token.prefix(50) + "...")
        }
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
        self.currentUser = nil
        self.isAuthenticated = false
        print("🔐 AUTH DEBUG - User signed out successfully")
    }
    
    func fetchTasks() async throws -> [Task] {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "SupabaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        print("🔐 AUTH DEBUG - Fetching tasks for user ID:", userId.uuidString)
        
        let userProjects = try await fetchProjects()
        let projectIds = userProjects.map { $0.id }
        
        print("🔐 AUTH DEBUG - User has \(projectIds.count) projects:", projectIds)
        
        guard !projectIds.isEmpty else {
            print("⚠️ AUTH DEBUG - No projects found for user, returning empty tasks")
            return []
        }
        
        let tasks: [Task] = try await client
            .from("tasks")
            .select()
            .eq("is_completed", value: false)
            .in("project_id", values: projectIds)
            .execute()
            .value
        
        print("🔐 AUTH DEBUG - Fetched \(tasks.count) tasks for user")
        
        return tasks
    }
    
    func fetchProjects() async throws -> [Project] {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "SupabaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        print("🔐 AUTH DEBUG - Fetching projects for user ID:", userId.uuidString)
        
        let projects: [Project] = try await client
            .from("projects")
            .select()
            .eq("user_id", value: userId.uuidString)
            .eq("archived", value: false)
            .execute()
            .value
        
        print("🔐 AUTH DEBUG - Fetched \(projects.count) projects for user")
        
        return projects
    }
    
    func completeTask(taskId: String) async throws {
        let update = TaskUpdate(isCompleted: true, updatedAt: Date())
        
        try await client
            .from("tasks")
            .update(update)
            .eq("id", value: taskId)
            .execute()
    }
}
