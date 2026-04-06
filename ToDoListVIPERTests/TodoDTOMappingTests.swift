import XCTest
@testable import ToDoListVIPER

final class TodoDTOMappingTests: XCTestCase {
    
    func test_toDomain_mapsTodoToTitle() {
        let dto = TodoDTO(id: 1, todo: "buy milk", completed: false, userId: 1)
        
        let task = dto.toDomain()
        
        XCTAssertEqual(task.title, "buy milk", "todo field should map to title")
    }
    
    func test_toDomain_mapsCompletedCorrectly() {
        let dto = TodoDTO(id: 1, todo: "test", completed: true, userId: 1)
        
        let task = dto.toDomain()
        
        XCTAssertTrue(task.isCompleted, "completed should map to isCompleted")
    }
    
    func test_toDomain_setsEmptyDescription() {
        let dto = TodoDTO(id: 1, todo: "test", completed: false, userId: 1)
        
        let task = dto.toDomain()
        
        XCTAssertEqual(task.description, "", "description should be empty from API")
    }
    
    func test_toDomain_mapsIdCorrectly() {
        let dto = TodoDTO(id: 42, todo: "Test", completed: false, userId: 1)
        
        let task = dto.toDomain()
        
        XCTAssertEqual(task.id, 42, "id should map correctly")
    }
    
    func test_toDomain_mapsNotCompletedCorrectly() {
        let dto = TodoDTO(id: 1, todo: "test", completed: false, userId: 1)
        
        let task = dto.toDomain()
        
        XCTAssertFalse(task.isCompleted, "false completed should map to false isCompleted")
    }
}
