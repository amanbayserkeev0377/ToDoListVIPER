import Foundation

final class TaskDetailInteractor {
    
    weak var output: TaskDetailInteractorOutputProtocol?
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService = .shared) {
        self.coreDataService = coreDataService
    }
}

// MARK: - TaskDetailInteractorProtocol

extension TaskDetailInteractor: TaskDetailInteractorProtocol {
    
    func createTask(title: String, description: String) {
        let task = ToDoTask(
            id: Int(Date().timeIntervalSince1970),
            title: title,
            description: description,
            isCompleted: false,
            createdAt: Date()
        )
        
        coreDataService.createTask(task) { [weak self] error in
            guard let self else { return }
            if let error {
                self.output?.didFailWithError(error)
            } else {
                NotificationCenter.default.post(name: .taskDidChange, object: nil)
            }
        }
    }
    
    func updateTask(_ task: ToDoTask, title: String, description: String) {
        var updatedTask = task
        updatedTask.title = title
        updatedTask.description = description
        
        coreDataService.updateTask(updatedTask) { [weak self] error in
            guard let self else { return }
            if let error {
                self.output?.didFailWithError(error)
            } else {
                NotificationCenter.default.post(name: .taskDidChange, object: nil)
            }
        }
    }
}

extension Notification.Name {
    static let taskDidChange = Notification.Name("taskDidChange")
}
