import UIKit

final class TaskDetailAssembly {
    
    static func build(mode: TaskDetailMode) -> UIViewController {
        
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter(mode: mode)
        let interactor = TaskDetailInteractor()
        let router = TaskDetailRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        router.viewController = view
        
        return view
    }
}
