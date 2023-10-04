//
//  UICollecitionView+Layout.swift
//  YouTubeClone
//
//  Created by Vebjørn Daniloff on 9/27/23.
//

import UIKit

extension NSCollectionLayoutSection {
    // MARK: - Video
    static func createVideoCellLayout() -> NSCollectionLayoutSection {
        let inset: CGFloat = 5

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1/3)
        )

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        group.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    // MARK: - Shorts
    static func createShortsCellLayout() -> NSCollectionLayoutSection {
        let inset: CGFloat = 5

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .fractionalHeight(1/3)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        group.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)

        let section = NSCollectionLayoutSection(group: group)

        // scrolling
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
}
