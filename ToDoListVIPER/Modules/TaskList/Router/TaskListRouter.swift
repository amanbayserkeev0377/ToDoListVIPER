import UIKit

final class TaskListRouter {
    
    weak var viewController: UIViewController?
}

// MARK: - TaskListRouterProtocol

extension TaskListRouter: TaskListRouterProtocol {
    
    func navigateToAddTask() {
        // TODO: navigate to TaskDetail screen (add mode)
        print("Navigate to add task")
    }
    
    func navigateToEditTask(_ task: ToDoTask) {
        // TODO: nav to taskdetail
        print("Navigate to edit task: \(task.id)")
    }
}
