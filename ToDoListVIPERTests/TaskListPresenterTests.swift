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
        // Act
        presenter.viewDidLoad()
        
        // Assert
        XCTAssertTrue(mockInteractor.fetchTasksCalled, "Presenter should trigger fetchTasks on interactor upon loading")
    }
    
    // MARK: - Interactor Output Tests
    
    func test_didFetchTasks_showTasksInView() {
        // Arrange
        let tasks = [ToDoTask(id: 1, title: "Test Task", description: "", isCompleted: false, createdAt: Date())]
        let expectation = expectation(description: "Wait for main thread dispatch")
        
        // Act
        presenter.didFetchTasks(tasks)
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        XCTAssertTrue(mockView.showTasksCalled, "View should be requested to display tasks")
        XCTAssertEqual(mockView.receivedTasks.count, 1, "View should receive the exact number of tasks")
    }
    
    func test_didFailWithError_showsErrorInView() {
        // Arrange
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network Error"])
        let expectation = expectation(description: "Wait for main thread dispatch")
        
        // Act
        presenter.didFailWithError(error)
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        XCTAssertTrue(mockView.showErrorCalled, "View should display an error message when data fetching fails")
    }
    
    // MARK: - User Action Tests
    
    func test_didTapAddTask_navigatesToAddTask() {
        // Act
        presenter.didTapAddTask()
        
        // Assert
        XCTAssertTrue(mockRouter.navigateToAddTaskCalled, "Presenter should request router to navigate to Add Task screen")
    }
    
    func test_didTapTask_navigatesToEditTask() {
        // Arrange
        let task = ToDoTask(id: 1, title: "Edit Task", description: "", isCompleted: false, createdAt: Date())
        
        // Act
        presenter.didTapTask(task)
        
        // Assert
        XCTAssertTrue(mockRouter.navigateToEditTaskCalled, "Presenter should request router to navigate to task details")
        XCTAssertEqual(mockRouter.receivedTask?.id, task.id, "Router should receive the correct task to edit")
    }
    
    func test_didDeleteTask_callsInteractor() {
        // Arrange
        let task = ToDoTask(id: 1, title: "Delete Task", description: "", isCompleted: false, createdAt: Date())
        
        // Act
        presenter.didDeleteTask(task)
        
        // Assert
        XCTAssertTrue(mockInteractor.deleteTaskCalled, "Presenter should notify interactor to perform deletion")
        XCTAssertEqual(mockInteractor.receivedTask?.id, task.id, "Interactor should receive the correct task for deletion")
    }
    
    func test_didSearchTasks_passesQueryToInteractor() {
        // Arrange
        let query = "Buy milk"
        
        // Act
        presenter.didSearchTasks(with: query)
        
        // Assert
        XCTAssertTrue(mockInteractor.searchTasksCalled, "Presenter should pass the search query to the interactor")
        XCTAssertEqual(mockInteractor.receivedQuery, query, "Interactor should receive the exact search string")
    }
}
