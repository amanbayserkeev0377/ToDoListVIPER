import Foundation

// Entity - pure data model, no logic here

struct ToDoTask: Sendable {
    let id: Int
    var title: String
    var description: String
    var isCompleted: Bool
    let createdAt: Date
}
