import Foundation

final class TaskDetailPresenter {
    
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorProtocol?
    
    private let mode: TaskDetailMode
    
    init(mode: TaskDetailMode) {
        self.mode = mode
    }
}

// MARK: - TaskDetailPresenterProtocol

extension TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    func viewDidLoad() {
        if case .edit(let task) = mode {
            view?.showTask(task)
        }
    }
    
    func didSaveTask(title: String, description: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            view?.showError("Название задачи не может быть пустым")
            return
        }
        
        switch mode {
        case .add:
            interactor?.createTask(title: title, description: description)
        case .edit(let task):
            interactor?.updateTask(task, title: title, description: description)
        }
    }
}

// MARK: - TaskDetailInteractorOutputProtocol

extension TaskDetailPresenter: TaskDetailInteractorOutputProtocol {
    
    func didFailWithError(_ error: any Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(error.localizedDescription)
        }
    }
}
