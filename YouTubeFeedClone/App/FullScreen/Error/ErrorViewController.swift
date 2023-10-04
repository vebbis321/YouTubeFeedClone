//
//  ErrorViewController.swift
//  NewsApp
//
//  Created by Vebjørn Daniloff on 9/28/23.
//

import SwiftUI
import UIKit

final class ErrorViewController: UIViewController {
    var retryAction: (() -> Void)?
    var err: YouTubeCloneError
    init(retryAction: (() -> Void)? = nil, err: YouTubeCloneError) {
        self.retryAction = retryAction
        self.err = err
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = UIHostingController(rootView: ErrorView(error: err, retryAction: retryAction))
        add(childView)
        childView.view.frame = view.bounds

    }
}
