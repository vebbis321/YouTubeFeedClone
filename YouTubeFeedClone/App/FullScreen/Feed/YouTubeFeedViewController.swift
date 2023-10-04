//
//  YouTubeFeedViewController.swift
//  YouTubeFeedClone
//
//  Created by Vebjorn Daniloff on 10/4/23.
//

import UIKit
import Combine

final class YouTubeFeedViewController: UIViewController {

    // MARK: - Private views/components
    private lazy var contentStateVC = ContentStateViewController()
    private lazy var contentVC: YouTubeFeedContentViewController?

    // MARK: - Private properties
    private let viewModel: YouTubeFeedViewModel

    // MARK: - LifeCycle
    init(viewModel: YouTubeFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - setup
    private func setup() {
        add(contentStateVC)
    }

    // MARK: - Private methods
    private func render(_ data: [Video]) {
        if contentStateVC.shownViewController == contentVC {
            contentVC?.snapData = data
        } else {
            contentVC = YouTubeFeedContentViewController(snapData: data)
            contentVC?.delegate = self
            contentStateVC.transition(to: .render(contentVC!))
        }
    }

    private func render(_ error: YouTubeCloneError) {
        contentStateVC.transition(to: .failed(error, action: { [weak self] in
//            self?.viewModel.perform(action: .loadFromAPI(retry: true))
        }))
    }
}
