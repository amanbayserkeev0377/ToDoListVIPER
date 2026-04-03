import Foundation

final class TaskListInteractor {
    
    // MARK: - Properties
    
    weak var output: TaskListInteractorOutputProtocol?
    
    private let backgroundQueue = DispatchQueue(
        label: "com.todolist.interactor",
        qos: .userInitiated
    )
}

// MARK: - TaskListInteractorProtocol

extension TaskListInteractor: TaskListInteractorProtocol {
    
    func fetchTasks() {
        backgroundQueue.async { [weak self] in
            self?.output?.didFetchTasks([])
        }
    }
    
    func toggleTask(_ task: ToDoTask) {
        backgroundQueue.async { [weak self] in
            print("Toggle task: \(task.id)")
        }
    }
    
    func deleteTask(_ task: ToDoTask) {
        backgroundQueue.async { [weak self] in
            print("Deleting task: \(task.id)")
        }
    }
    
    func searchTasks(with query: String) {
        backgroundQueue.async { [weak self] in
            print("Searching: \(query)")
        }
    }
}
