import Foundation

final class TaskListPresenter {
    
    // MARK: - Properties
    
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
}

// MARK: - TaskListPresenterProtocol

extension TaskListPresenter: TaskListPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func didTapAddTask() {
        router?.navigateToAddTask()
    }
    
    func didTapTask(_ task: ToDoTask) {
        router?.navigateToEditTask(task)
    }
    
    func didDeleteTask(_ task: ToDoTask) {
        interactor?.deleteTask(task)
    }
    
    func didSearchTasks(with query: String) {
        interactor?.searchTasks(with: query)
    }
}

// MARK: - TaskListInteractorOutputProtocol

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    
    func didFetchTasks(_ tasks: [ToDoTask]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showTasks(tasks)
        }
    }
    
    func didFailWithError(_ error: any Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(error.localizedDescription)
        }
    }
}
