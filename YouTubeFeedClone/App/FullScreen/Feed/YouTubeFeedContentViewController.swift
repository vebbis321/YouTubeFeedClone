//
//  YouTubeFeedContentViewController.swift
//  YouTubeFeedClone
//
//  Created by Vebjorn Daniloff on 10/4/23.
//

import UIKit

final class YouTubeFeedContentViewController: UIViewController {

    // MARK: - Types
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Article>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Article>

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
    weak var delegate: NewsContentViewControllerDelegate?

    var snapData: [Article] {
        didSet {
            updateSnapshot()
        }
    }

    // MARK: - LifeCycle
    init(snapData: [Article]) {
        self.snapData = snapData
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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            return .createNewsLayout()
        }
        return layout
    }

    // MARK: - CollectionView dataSource
    private func configureDataSource() {

        let articleCellRegistration = UICollectionView.CellRegistration<ArticleCardCell, Article> { cell, indexPath, model in
            cell.configure(with: .init(article: model))
            cell.accessibilityIdentifier = "ArticleCell"
        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(elementKind: UICollectionView.elementKindSectionFooter) {
            (footer, elementKind, indexPath) in
            footer.contentConfiguration = UIHostingConfiguration {
                ProgressView()
            }
        }

        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: articleCellRegistration,
                for: indexPath,
                item: item
            )
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let footer = collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            return footer
        }

    }

    // MARK: - Update snapshot
    @MainActor
    private func updateSnapshot(animated: Bool = true) {
        snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(snapData, toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func collectionViewReachedEnd() {
        guard let footer = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter).first else { return }
        footer.isHidden = true
    }
}

// MARK: - UICollectionViewDelegate
extension NewsContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let article = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        delegate?.didTap(article)

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
