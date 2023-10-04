//
//  LoadingViewController.swift
//  NewsApp
//
//  Created by Vebjørn Daniloff on 9/28/23.
//

import SwiftUI

final class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = UIHostingController(rootView: LoadingView())
        add(childView)
        childView.view.pin(to: view)
    }
}
