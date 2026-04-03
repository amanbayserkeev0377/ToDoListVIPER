import Foundation

struct TodoResponseDTO: Decodable {
    let todos: [TodoDTO]
    let total: Int
}

struct TodoDTO: Decodable {
    let id: Int
    let todo: String // API calls it "todo", app call it "title"
    let completed: Bool
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case todo
        case completed
        case userId
    }
    
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
