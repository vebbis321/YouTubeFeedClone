//
//  YouTubeFeedContentViewController.swift
//  YouTubeFeedClone
//
//  Created by Vebjorn Daniloff on 10/4/23.
//

import UIKit
import SwiftUI

struct YouTubeFeedContentViewModel: Equatable {
    var videos: [Video]

    var firstVideo: Video? {
        videos.first
    }

    var shorts: [Video] {
        videos.filter { $0.width == 1920 && $0.height == 1080 }
    }

    var feedVideos: [Video] {
        videos.filter({ !shorts.contains($0) })
    }

    enum Item: Hashable {
        case shorts(Video)
        case feedVideos(Video)
    }

    var items: [Item] {
        feedVideos.map { .feedVideos($0) } + shorts.map { .shorts($0) }
    }

}

protocol YouTubeFeedContentViewControllerDelegate: AnyObject {
    func didScrollToEnd()
    func didTap(_ video: YouTubeFeedContentViewController.Item)
}

final class YouTubeFeedContentViewController: UIViewController {

    // MARK: - Private Components
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .appColor(.background)
        return collectionView
    }()

    // MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!

    // MARK: - Internal properties
    weak var delegate: YouTubeFeedContentViewControllerDelegate?

    var viewModel: YouTubeFeedContentViewModel {
        didSet {
            updateSnapshot()
        }
    }

    // MARK: - LifeCycle
    init(viewModel: YouTubeFeedContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureDataSource()
        updateSnapshot(animated: false)
    }

    // MARK: - setup
    private func setup() {
        view.backgroundColor = .appColor(.background)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    // MARK: - CollectionView layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }

            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .singleFeedVideo, .feedVideo:
                return .createVideoCellLayout()
            case .shorts:
                return .createShortsCellLayout()
            }
        }
        return layout
    }

    // MARK: - CollectionView dataSource
    private func configureDataSource() {
        let videoCellRegistration = UICollectionView.CellRegistration<ShortsCardCell, Video> { cell, _, model in

        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(elementKind: UICollectionView.elementKindSectionFooter) {
            (footer, elementKind, indexPath) in
            footer.contentConfiguration = UIHostingConfiguration {
                ProgressView()
            }
        }

        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .shorts(let model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: videoCellRegistration,
                    for: indexPath,
                    item: model
                )
            case .feedVideos(let model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: videoCellRegistration,
                    for: indexPath,
                    item: model
                )
            }
        }

    }

    // MARK: - Update snapshot
    @MainActor
    private func updateSnapshot(animated: Bool = true) {
        snapshot = Snapshot()
        snapshot.appendSections(snapData.map { $0.key })
        for datum in snapData {
            snapshot.appendItems(datum.values, toSection: datum.key)
        }

        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func collectionViewReachedEnd() {
        guard let footer = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter).first else { return }
        footer.isHidden = true
    }
}

// MARK: - UICollectionViewDelegate
extension YouTubeFeedContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        delegate?.didTap(item)

        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1

        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            delegate?.didScrollToEnd()
        }
    }
}

extension YouTubeFeedContentViewController {
    enum Section {
        case singleFeedVideo
        case shorts
        case feedVideo
    }

    enum Item: Hashable {
        case shorts(Video)
        case feedVideos(Video)
    }

    struct SnapData {
        var key: Section
        var values: [Item]
    }

    // MARK: - Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
}
