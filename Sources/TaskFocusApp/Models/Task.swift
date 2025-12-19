import Foundation

struct Task: Codable, Identifiable, Equatable {
    let id: String
    let projectId: String
    let content: String
    let isCompleted: Bool
    let position: Int
    let createdAt: Date
    let updatedAt: Date
    let howExplanation: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case content
        case isCompleted = "is_completed"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case howExplanation = "how_explanation"
    }
    
    var estimatedDuration: Int? {
        guard let explanation = howExplanation else { return nil }
        let numbers = explanation.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .compactMap { Int($0) }
        return numbers.first
    }
}

struct TaskUpdate: Codable {
    let isCompleted: Bool
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case isCompleted = "is_completed"
        case updatedAt = "updated_at"
    }
}
