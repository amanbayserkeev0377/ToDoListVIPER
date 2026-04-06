import XCTest
@testable import ToDoListVIPER

final class TaskDetailPresenterTests: XCTestCase {
    
    // MARK: - Properties
    var mockView: MockTaskDetailView!
    var mockInteractor: MockTaskDetailInteractor!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockView = MockTaskDetailView()
        mockInteractor = MockTaskDetailInteractor()
    }
    
    override func tearDown() {
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    // MARK: - Lifecycle Tests
    
    func test_viewDidLoad_editMode_showsTask() {
        let task = ToDoTask(id: 1, title: "Test", description: "Desc", isCompleted: false, createdAt: Date())
        let presenter = makePresenter(mode: .edit(task))
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockView.showTaskCalled, "View should be requested to display task data in edit mode")
        XCTAssertEqual(mockView.receivedTask?.id, task.id, "View should receive the correct task for editing")
    }
    
    func test_viewDidLoad_addMode_doesNotShowTask() {
        let presenter = makePresenter(mode: .add)
        
        presenter.viewDidLoad()
        
        XCTAssertFalse(mockView.showTaskCalled, "View should not receive any task data in add mode")
    }
    
    // MARK: - Validation Tests
    
    func test_didSaveTask_emptyTitle_showsError() {
        let presenter = makePresenter(mode: .add)
        
        presenter.didSaveTask(title: "", description: "Some description")
        
        XCTAssert(mockView.showErrorCalled, "Empty title should show error")
        XCTAssertFalse(mockInteractor.createTaskCalled, "Should NOT create task with empty title")
    }
    
    func testDidSaveTask_whitespaceTitle_showsError() {
        let presenter = makePresenter(mode: .add)
        
        presenter.didSaveTask(title: "    ", description: "")
        
        XCTAssertTrue(mockView.showErrorCalled, "Whitespace title should show error")
        XCTAssertFalse(mockInteractor.createTaskCalled, "Should NOT create task")
    }
    
    // MARK: - Business Logic Tests
    
    func test_didSaveTask_addMode_createsTask() {
        let presenter = makePresenter(mode: .add)
        let newTitle = "New Task"
        
        presenter.didSaveTask(title: newTitle, description: "Description")
        
        XCTAssertTrue(mockInteractor.createTaskCalled, "Interactor should be requested to create a new task")
        XCTAssertEqual(mockInteractor.receivedTitle, newTitle, "Interactor should receive the correct title for the new task")
    }
    
    func test_didSaveTask_editMode_updatesTask() {
        let task = ToDoTask(id: 1, title: "Old title", description: "Old description", isCompleted: false, createdAt: Date())
        let presenter = makePresenter(mode: .edit(task))
        let updatedTitle = "Updated Title"
        
        presenter.didSaveTask(title: updatedTitle, description: "Updated Description")
        
        XCTAssertTrue(mockInteractor.updateTaskCalled, "Edit mode should update task")
        XCTAssertEqual(mockInteractor.receivedTitle, updatedTitle, "Interactor should receive the updated title")
        XCTAssertFalse(mockInteractor.createTaskCalled, "Edit mode should NOT create new task")
    }
    
    // MARK: - Helpers
    
    private func makePresenter(mode: TaskDetailMode) -> TaskDetailPresenter {
        let presenter = TaskDetailPresenter(mode: mode)
        presenter.view = mockView
        presenter.interactor = mockInteractor
        return presenter
    }
}

