import Foundation

enum TaskDetailMode {
    case add
    case edit(ToDoTask)
}

// MARK: - View
protocol TaskDetailViewProtocol: AnyObject {
    func showTask(_ task: ToDoTask)
    func showError(_ message: String)
}

// MARK: - Presenter
protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSaveTask(title: String, description: String)
}

// MARK: - Interactor
protocol TaskDetailInteractorProtocol: AnyObject {
    func createTask(title: String, description: String)
    func updateTask(_ task: ToDoTask, title: String, description: String)
}

// MARK: - Interactor Output
protocol TaskDetailInteractorOutputProtocol: AnyObject {
    func didFailWithError(_ error: Error)
}
