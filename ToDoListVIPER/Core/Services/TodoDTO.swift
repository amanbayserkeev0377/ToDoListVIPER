import Foundation

struct TodoResponseDTO: Decodable, Sendable {
    let todos: [TodoDTO]
    let total: Int
}

struct TodoDTO: Decodable, Sendable {
    let id: Int
    let todo: String // API calls it "todo", app call it "title"
    let completed: Bool
    let userId: Int
    
    func toDomain() -> ToDoTask {
        return ToDoTask(
            id: id,
            title: todo, // "todo" -> "title"
            description: "", // API without description, user fills later
            isCompleted: completed,
            createdAt: Date() // API without date, use current date
        )
    }
}
