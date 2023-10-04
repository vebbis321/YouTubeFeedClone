//
//  YouTubeFeedViewController.swift
//  YouTubeFeedClone
//
//  Created by Vebjorn Daniloff on 10/4/23.
//

import UIKit
import Combine

final class YouTubeFeedViewController: UIViewController {

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

    }
}
