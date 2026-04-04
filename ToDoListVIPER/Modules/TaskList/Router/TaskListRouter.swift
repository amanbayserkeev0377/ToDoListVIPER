import UIKit

final class TaskListRouter {
    
    weak var viewController: UIViewController?
}

// MARK: - TaskListRouterProtocol

extension TaskListRouter: TaskListRouterProtocol {
    
    func navigateToAddTask() {
        let detailVC = TaskDetailAssembly.build(mode: .add)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func navigateToEditTask(_ task: ToDoTask) {
        let detailVC = TaskDetailAssembly.build(mode: .edit(task))
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
