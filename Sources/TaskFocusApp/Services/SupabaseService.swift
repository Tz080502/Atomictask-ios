import Foundation
import Supabase
import CryptoKit

struct SupabaseUser: Codable {
    let id: String
    let email: String
    let password: String
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, email, password
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

@MainActor
class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    @Published var currentUser: SupabaseUser?
    @Published var isAuthenticated = false
    
    private let userIdKey = "current_user_id"
    private let userEmailKey = "current_user_email"
    
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
        guard let userId = UserDefaults.standard.string(forKey: userIdKey),
              let email = UserDefaults.standard.string(forKey: userEmailKey) else {
            self.currentUser = nil
            self.isAuthenticated = false
            print("⚠️ AUTH DEBUG - No active session found")
            return
        }
        
        do {
            let users: [SupabaseUser] = try await client
                .from("users")
                .select()
                .eq("id", value: userId)
                .execute()
                .value
            
            if let user = users.first {
                self.currentUser = user
                self.isAuthenticated = true
                print("🔐 AUTH DEBUG - Session restored for user:", user.id)
                print("🔐 AUTH DEBUG - User email:", user.email)
            } else {
                clearSession()
            }
        } catch {
            print("⚠️ AUTH DEBUG - Failed to restore session:", error.localizedDescription)
            clearSession()
        }
    }
    
    func signIn(email: String, password: String) async throws {
        print("🔐 AUTH DEBUG - Attempting sign in for:", email)
        
        let users: [SupabaseUser] = try await client
            .from("users")
            .select()
            .eq("email", value: email)
            .execute()
            .value
        
        guard let user = users.first else {
            throw NSError(domain: "SupabaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        if user.password != password {
            throw NSError(domain: "SupabaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid password"])
        }
        
        self.currentUser = user
        self.isAuthenticated = true
        
        UserDefaults.standard.set(user.id, forKey: userIdKey)
        UserDefaults.standard.set(user.email, forKey: userEmailKey)
        
        print("✅ AUTH DEBUG - Sign in successful, user ID:", user.id)
    }
    
    func signUp(email: String, password: String) async throws {
        print("🔐 AUTH DEBUG - Attempting sign up for:", email)
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        let existingUsers: [SupabaseUser] = try await client
            .from("users")
            .select()
            .eq("email", value: email)
            .execute()
            .value
        
        if !existingUsers.isEmpty {
            throw NSError(domain: "SupabaseService", code: 409, userInfo: [NSLocalizedDescriptionKey: "User already exists"])
        }
        
        let newUser = [
            "email": email,
            "password": password
        ]
        
        let createdUsers: [SupabaseUser] = try await client
            .from("users")
            .insert(newUser)
            .select()
            .execute()
            .value
        
        guard let user = createdUsers.first else {
            throw NSError(domain: "SupabaseService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to create user"])
        }
        
        self.currentUser = user
        self.isAuthenticated = true
        
        UserDefaults.standard.set(user.id, forKey: userIdKey)
        UserDefaults.standard.set(user.email, forKey: userEmailKey)
        
        print("✅ AUTH DEBUG - Sign up successful, user ID:", user.id)
    }
    
    func signOut() async throws {
        clearSession()
        print("🔐 AUTH DEBUG - User signed out successfully")
    }
    
    private func clearSession() {
        self.currentUser = nil
        self.isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
    }
    
    func fetchTasks() async throws -> [Task] {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "SupabaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        print("🔐 AUTH DEBUG - Fetching tasks for user ID:", userId)
        
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
        
        print("🔐 AUTH DEBUG - Fetching projects for user ID:", userId)
        
        let projects: [Project] = try await client
            .from("projects")
            .select()
            .eq("user_id", value: userId)
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
