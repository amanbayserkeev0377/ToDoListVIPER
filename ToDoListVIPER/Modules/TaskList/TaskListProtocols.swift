// Contracts between VIPER layers

import UIKit

// MARK: - View
protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [ToDoTask])
    func showError(_ message: String)
}

// MARK: - Presenter
protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapAddTask()
    func didTapTask(_ task: ToDoTask)
    func didToggleTask(_ task: ToDoTask)
    func didDeleteTask(_ task: ToDoTask)
    func didSearchTasks(with query: String)
}

// MARK: - Interactor
protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    func toggleTask(_ task: ToDoTask)
    func deleteTask(_ task: ToDoTask)
    func searchTasks(with query: String)
}

// MARK: - Interactor Output
protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [ToDoTask])
    func didFailWithError(_ error: Error)
}

// MARK: - Router
protocol TaskListRouterProtocol: AnyObject {
    func navigateToAddTask()
    func navigateToEditTask(_ task: ToDoTask)
}
