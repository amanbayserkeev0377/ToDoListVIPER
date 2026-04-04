//
//  SceneDelegate.swift
//  ToDoListVIPER
//
//  Created by Aman Bayserkeev on 3/4/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootViewController = TaskListAssembly.build()
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.overrideUserInterfaceStyle = .dark
        window?.tintColor = .appTint
        window?.makeKeyAndVisible()
    }
}

