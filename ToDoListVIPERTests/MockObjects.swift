import Foundation
@testable import ToDoListVIPER

// MARK: - Mock View (for TaskList)
final class MockTaskListView: TaskListViewProtocol {
    
    var showTasksCalled = false
    var showErrorCalled = false
    var receivedTasks: [ToDoTask] = []
    var receivedError: String?
    
    func showTasks(_ tasks: [ToDoTask]) {
        showTasksCalled = true
        receivedTasks = tasks
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
        receivedError = message
    }
}

// MARK: - Mock Interactor (for TaskList)
final class MockTaskListInteractor: TaskListInteractorProtocol {
    
    var fetchTasksCalled = false
    var toggleTaskCalled = false
    var deleteTaskCalled = false
    var searchTasksCalled = false
    var receivedQuery: String?
    var receivedTask: ToDoTask?
    
    func fetchTasks() {
        fetchTasksCalled = true
    }
    
    func toggleTask(_ task: ToDoTask) {
        toggleTaskCalled = true
        receivedTask = task
    }
    
    func deleteTask(_ task: ToDoTask) {
        deleteTaskCalled = true
        receivedTask = task
    }
    
    func searchTasks(with query: String) {
        searchTasksCalled = true
        receivedQuery = query
    }
}

// MARK: - Mock Router (for TaskList)
final class MockTaskListRouter: TaskListRouterProtocol {
    
    var navigateToAddTaskCalled = false
    var navigateToEditTaskCalled = false
    var receivedTask: ToDoTask?
    
    func navigateToAddTask() {
        navigateToAddTaskCalled = true
    }
    
    func navigateToEditTask(_ task: ToDoTask) {
        navigateToEditTaskCalled = true
        receivedTask = task
    }
}

// MARK: - Mock View (for TaskDetail)
final class MockTaskDetailView: TaskDetailViewProtocol {
    
    var showTaskCalled = false
    var showErrorCalled = false
    var receivedTask: ToDoTask?
    var receivedError: String?
    
    func showTask(_ task: ToDoTask) {
        showTaskCalled = true
        receivedTask = task
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
        receivedError = message
    }
}

// MARK: - Mock Interactor (for TaskDetail)
final class MockTaskDetailInteractor: TaskDetailInteractorProtocol {
    
    var createTaskCalled = false
    var updateTaskCalled = false
    var receivedTitle: String?
    var receivedDescription: String?
    
    func createTask(title: String, description: String) {
        createTaskCalled = true
        receivedTitle = title
        receivedDescription = description
    }
    
    func updateTask(_ task: ToDoTask, title: String, description: String) {
        updateTaskCalled = true
        receivedTitle = title
        receivedDescription = description
    }
}
