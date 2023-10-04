//
//  InAppCoordinator.swift
//  NewsApp
//
//  Created by Vebjørn Daniloff on 9/28/23.
//

import UIKit

final class InAppCoordinator: StateCoordinator {

    weak var parentCoordinator: ApplicationCoordinator?

    var rootViewController: UINavigationController = .init()

    func start() {
        let viewModel = YouTubeFeedViewModel()
        let vc = YouTubeFeedViewController(viewModel: viewModel)
        rootViewController.pushViewController(vc, animated: false)
    }
}

