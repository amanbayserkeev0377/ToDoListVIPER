import XCTest
@testable import ToDoListVIPER

final class TaskListPresenterTests: XCTestCase {
    
    // MARK: - Properties
    private var presenter: TaskListPresenter!
    private var mockView: MockTaskListView!
    private var mockInteractor: MockTaskListInteractor!
    private var mockRouter: MockTaskListRouter!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        presenter = TaskListPresenter()
        mockView = MockTaskListView()
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    // MARK: - Lifecycle Tests
    
    func test_viewDidLoad_callsFetchTasks() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchTasksCalled, "viewDidLoad should call interactor.fetchTasks()")
    }
    
    // MARK: - Interactor Output Tests
    
    func test_didFetchTasks_showTasksInView() {
        let tasks = [ToDoTask(id: 1, title: "Test Task", description: "", isCompleted: false, createdAt: Date())]
        let expectation = expectation(description: "showTasks called on main thread")
        
        presenter.didFetchTasks(tasks)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        XCTAssertTrue(mockView.showTasksCalled, "didFetchTasks should call view.showTasks()")
        XCTAssertEqual(mockView.receivedTasks.count, 1, "View should receive 1 task")
    }
    
    func test_didFailWithError_showsErrorInView() {
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network Error"])
        let expectation = expectation(description: "showError called on main thread")
        
        presenter.didFailWithError(error)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        XCTAssertTrue(mockView.showErrorCalled, "didFailWithError should call view.showError()")
    }
    
    // MARK: - User Action Tests
    
    func test_didTapAddTask_navigatesToAddTask() {
        presenter.didTapAddTask()
        
        XCTAssertTrue(mockRouter.navigateToAddTaskCalled, "didTapAddTask should call router.navigateToAddTask()")
    }
    
    func test_didTapTask_navigatesToEditTask() {
        let task = ToDoTask(id: 1, title: "Edit Task", description: "", isCompleted: false, createdAt: Date())
        
        presenter.didTapTask(task)
        
        XCTAssertTrue(mockRouter.navigateToEditTaskCalled, "didTapTask should call router.navigateToEditTask()")
        XCTAssertEqual(mockRouter.receivedTask?.id, task.id, "Router should receive correct task")
    }
    
    func test_didDeleteTask_callsInteractor() {
        let task = ToDoTask(id: 1, title: "Delete Task", description: "", isCompleted: false, createdAt: Date())
        
        presenter.didDeleteTask(task)
        
        XCTAssertTrue(mockInteractor.deleteTaskCalled, "didDeleteTask should call interactor.deleteTask()")
        XCTAssertEqual(mockInteractor.receivedTask?.id, task.id, "Interactor should receive the correct task for deletion")
    }
    
    func test_didSearchTasks_passesQueryToInteractor() {
        let query = "Buy milk"
        
        presenter.didSearchTasks(with: query)
        
        XCTAssertTrue(mockInteractor.searchTasksCalled, "didSearchTasks should call interactor.searchTasks()")
        XCTAssertEqual(mockInteractor.receivedQuery, query, "Interactor should receive the exact search string")
    }
}
