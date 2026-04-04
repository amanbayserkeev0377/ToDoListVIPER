import Foundation

final class TaskListInteractor {
    
    // MARK: - Properties
    
    weak var output: TaskListInteractorOutputProtocol?
    
    private let coreDataService: CoreDataService
    private let networkService: NetworkService
    
    private let backgroundQueue = DispatchQueue(
        label: "com.todolist.interactor",
        qos: .userInitiated
    )
    
    // MARK: - Init
    init(
        coreDataService: CoreDataService = .shared,
        networkService: NetworkService = .shared
    ) {
        self.coreDataService = coreDataService
        self.networkService = networkService
    }
}

// MARK: - TaskListInteractorProtocol

extension TaskListInteractor: TaskListInteractorProtocol {
    
    func fetchTasks() {
        coreDataService.isEmpty { [weak self] isEmpty in
            guard let self else { return }
            
            if isEmpty {
                self.fetchFromNetwork()
            } else {
                self.fetchFromCoreData()
            }
        }
    }
    
    func toggleTask(_ task: ToDoTask) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        
        coreDataService.updateTask(updatedTask) { [weak self] error in
            guard let self else { return }
            if let error {
                self.output?.didFailWithError(error)
            } else {
                self.fetchFromCoreData()
            }
        }
    }
    
    func deleteTask(_ task: ToDoTask) {
        coreDataService.deleteTask(task) { [weak self] error in
            guard let self else { return }
            if let error {
                self.output?.didFailWithError(error)
            } else {
                self.fetchFromCoreData()
            }
        }
    }
    
    func searchTasks(with query: String) {
        if query.isEmpty {
            fetchFromCoreData()
            return
        }
        
        coreDataService.searchTasks(query: query) { [weak self] tasks, error in
            guard let self else { return }
            if let error {
                self.output?.didFailWithError(error)
            } else {
                self.output?.didFetchTasks(tasks)
            }
        }
    }
}

// MARK: - Private

private extension TaskListInteractor {
    
    func fetchFromCoreData() {
        coreDataService.fetchTasks { [weak self] tasks, error in
            guard let self else { return }
            if let error {
                self.output?.didFailWithError(error)
            } else {
                self.output?.didFetchTasks(tasks)
            }
        }
    }
    
    func fetchFromNetwork() {
        networkService.fetchTodos { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let tasks):
                self.saveTasksToCoreData(tasks)
            case .failure(let error):
                self.output?.didFailWithError(error)
            }
        }
    }
    
    func saveTasksToCoreData(_ tasks: [ToDoTask]) {
        let group = DispatchGroup()
        var saveError: Error?
        
        for task in tasks {
            group.enter()
            coreDataService.createTask(task) { error in
                if let error {
                    saveError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            if let error = saveError {
                self.output?.didFailWithError(error)
            } else {
                self.fetchFromCoreData()
            }
        }
    }
}
