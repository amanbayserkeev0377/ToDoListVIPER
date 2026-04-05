import XCTest
@testable import ToDoListVIPER

final class TaskDetailPresenterTests: XCTestCase {
    
    var mockView: MockTaskDetailView!
    var mockInteractor: MockTaskDetailInteractor!
    
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
    
    // Test 1: viewDidLoad 
}
