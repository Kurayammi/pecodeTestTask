//
//  MainCoordinator.swift
//  Pecode Test
//
//  Created by Kito on 11/6/22.
//

import UIKit

final class MainCoordinator {
    
    private(set) var window: UIWindow
    private var navigationController: UINavigationController?
    
    func start() {
        let newsScreen = MainScreenViewController()
        
        newsScreen.start(pushSavedArticlesScreen: pushSavedArticlesScreen)
        navigationController = UINavigationController(rootViewController: newsScreen)
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
    }
    
    func pushSavedArticlesScreen() {
        let vc = SavedArticlesScreenViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    init(window: UIWindow) {
        self.window = window
    }
}
