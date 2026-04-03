import Foundation

extension TaskEntity {
    
    func toDomain() -> ToDoTask? {
        guard let title, let createdAt else { return nil }
        
        return ToDoTask(
            id: Int(id),
            title: title,
            description: desc ?? "",
            isCompleted: isCompleted,
            createdAt: createdAt
        )
    }
}
