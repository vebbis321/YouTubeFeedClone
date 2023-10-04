//
//  VideoCell.swift
//  YouTubeClone
//
//  Created by Vebjørn Daniloff on 9/27/23.
//

import UIKit
import SDWebImage

final class ShortsCardCell: UICollectionViewCell {

    // MARK: - Components
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()


    // MARK: - LifeCycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 10
        clipsToBounds = true

        addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private func loadImage(with viewModel: Video?) {
        guard let url = URL(string: viewModel?.image ?? "") else { return }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "house"))
    }
}
