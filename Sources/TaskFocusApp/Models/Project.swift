import Foundation

struct Project: Codable, Identifiable, Equatable {
    let id: String
    let userId: String
    let name: String
    let position: Int
    let createdAt: Date
    let updatedAt: Date
    let type: String
    let goalDescription: String?
    let goalStepCount: Int
    let archived: Bool
    let workspaceId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case type
        case goalDescription = "goal_description"
        case goalStepCount = "goal_step_count"
        case archived
        case workspaceId = "workspace_id"
    }
}
