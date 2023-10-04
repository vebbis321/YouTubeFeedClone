//
//  SceneDelegate.swift
//  YouTubeFeedClone
//
//  Created by Vebjorn Daniloff on 10/4/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    var applicationCoordinator: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let applicationCoordinator = ApplicationCoordinator(window: window)
        applicationCoordinator.start()
        self.applicationCoordinator = applicationCoordinator

        window.makeKeyAndVisible()
    }
}

