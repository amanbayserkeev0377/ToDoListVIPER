import UIKit

final class TaskDetailRouter {
    weak var viewController: UIViewController?
}

extension TaskDetailRouter: TaskDetailRouterProtocol {
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
