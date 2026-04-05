import XCTest
@testable import ToDoListVIPER

final class TaskListPresenterTests: XCTestCase {
    
    // MARK: - Properties
    var presenter: TaskListPresenter!
    var mockView: MockTaskListView!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!
    
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
    
    // MARK: - Tests
    
    // Test 1: viewDidLoad calls fetchTasks
    func test_viewDidLoad_callsFetchTasks() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchTasksCalled, "viewDidLoad should call interactor.fetchTasks")
    }
    
    // Test 2: didFetchTasks passes tasks to view
    func test_didFetchTasks_showTasksInView() {
        let tasks = [
            ToDoTask(id: 1, title: "Test", description: "", isCompleted: false, createdAt: Date())
        ]
        
        let expectation = expectation(description: "showTasks called on main thread")
        presenter.didFetchTasks(tasks)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertTrue(mockView.showTasksCalled, "didFetchTasks should call view.showTasks()")
        XCTAssertEqual(mockView.receivedTasks.count, 1, "View should receive 1 task")
    }
    
    // Test 3: didTapAddTask calls router
    func test_didTapAddTask_navigatesToAddTask() {
        presenter.didTapAddTask()
        
        XCTAssertTrue(mockRouter.navigateToAddTaskCalled, "didTapAddTask should call router.navigateToAddTask()")
    }
    
    // Test 4: didTapTask calls router with correct task
    func test_didTapTask_navigatesToEditTask() {
        let task = ToDoTask(id: 1, title: "Test", description: "", isCompleted: false, createdAt: Date())
        
        presenter.didTapTask(task)
        
        XCTAssertTrue(mockRouter.navigateToEditTaskCalled, "didTapTask should call router.navigateToEditTask()")
        XCTAssertEqual(mockRouter.receivedTask?.id, task.id, "Router should receive correct task")
    }
    
    // Test 5: didDeleteTask calls interactor
    func test_didDeleteTask_callsInteractor() {
        let task = ToDoTask(id: 1, title: "Test", description: "", isCompleted: false, createdAt: Date())
        
        presenter.didDeleteTask(task)
        
        XCTAssertTrue(mockInteractor.deleteTaskCalled, "didDeleteTask should call interactor.deleteTask()")
        XCTAssertEqual(mockInteractor.receivedTask?.id, task.id, "Interactor should receive correct task")
    }
    
    // Test 6: didSearchTasks passes query to interactor
    func test_didSearchTasks_passesQueryToInteractor() {
        let query = "купить"
        
        presenter.didSearchTasks(with: query)
        
        XCTAssertTrue(mockInteractor.searchTasksCalled, "didSearchTasks should call interactor.searchTasks()")
        XCTAssertEqual(mockInteractor.receivedQuery, query, "Interactor should receive correct query")
    }
    
    // Test 7: didFailWithError shows error in view
    func test_didFailWithError_showsErrorInView() {
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        
        let expectation = expectation(description: "showError called on main thread")
        presenter.didFailWithError(error)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        XCTAssertTrue(mockView.showErrorCalled, "didFailWithError should call view.showError()")
    }
}
