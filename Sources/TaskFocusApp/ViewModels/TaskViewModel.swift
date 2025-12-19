import Foundation
import SwiftUI

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var projects: [Project] = []
    @Published var currentTask: Task?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showCongratsScreen = false
    
    private let supabaseService = SupabaseService.shared
    private let swipeLimitService = SwipeLimitService.shared
    
    var projectsDict: [String: Project] = [:]
    
    func loadTasks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let tasksResult = supabaseService.fetchTasks()
            async let projectsResult = supabaseService.fetchProjects()
            
            let (fetchedTasks, fetchedProjects) = try await (tasksResult, projectsResult)
            
            self.projects = fetchedProjects
            self.projectsDict = Dictionary(uniqueKeysWithValues: fetchedProjects.map { ($0.id, $0) })
            
            self.tasks = sortTasks(fetchedTasks)
            self.currentTask = tasks.first
            
            if tasks.isEmpty {
                showCongratsScreen = true
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func completeCurrentTask() async {
        guard let task = currentTask else { return }
        
        do {
            try await supabaseService.completeTask(taskId: task.id)
            
            tasks.removeAll { $0.id == task.id }
            
            if tasks.isEmpty {
                currentTask = nil
                showCongratsScreen = true
            } else {
                currentTask = tasks.first
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func skipCurrentTask() {
        guard let task = currentTask else { return }
        guard swipeLimitService.canSkip else { return }
        
        swipeLimitService.recordSkip()
        
        tasks.removeAll { $0.id == task.id }
        tasks.append(task)
        
        currentTask = tasks.first
    }
    
    func sortTasks(_ tasks: [Task]) -> [Task] {
        let preference = swipeLimitService.getSortPreference()
        
        return tasks.sorted { task1, task2 in
            let duration1 = task1.estimatedDuration ?? Int.max
            let duration2 = task2.estimatedDuration ?? Int.max
            
            switch preference {
            case .quickFirst:
                return duration1 < duration2
            case .hardFirst:
                return duration1 > duration2
            }
        }
    }
    
    func refreshTasks() async {
        await loadTasks()
    }
    
    func getProjectName(for projectId: String) -> String {
        projectsDict[projectId]?.name ?? "Unknown Project"
    }
}
