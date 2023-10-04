//
//  ContentStateViewController.swift
//  NewsApp
//
//  Created by Vebjørn Daniloff on 9/28/23.
//

import UIKit

final class ContentStateViewController: UIViewController {
    private var state: State?
    var shownViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        if state == nil {
            transition(to: .loading)
        }
    }

    func transition(to newState: State) {
        shownViewController?.remove()
        let vc = viewController(for: newState)
        vc.view.alpha = 0
        add(vc)
        shownViewController = vc
        state = newState
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
            vc.view.alpha = 1
        }
    }
}

private extension ContentStateViewController {
    func viewController(for state: State) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()

        case let .failed(error, action):
            return ErrorViewController(retryAction: action, err: error)
            
        case let .render(viewController):
            return viewController
        }
    }
}

extension ContentStateViewController {
    enum State {
        case loading
        case failed(YouTubeCloneError, action: ()->())
        case render(UIViewController)
    }
}
