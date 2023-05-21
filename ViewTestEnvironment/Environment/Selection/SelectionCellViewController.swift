//
//  SelectionCellViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import Combine
import UIKit

final class SelectionCellViewController: UIViewController {
    // MARK: - Constant
    private static let cellReuseID: String = "selection-cell"
    
    // MARK: - Alias
    private typealias ViewCell = UICollectionView.CellRegistration<
        SelectionCell,
        SelectionItem
    >
    
    // MARK: - Property
    private var selectedIndex: Int = .zero

    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel(font: .preferredFont(forTextStyle: .title1), color: .white)
        label.text = "View Checker"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.addAction(.init(handler: { [weak self] _ in
            self?.confirmButtonTapped()
        }), for: .touchUpInside)

        return button
    }()
    
    private lazy var collectionLayout: ZoomSelectionFlowLayout = {
        let layout: ZoomSelectionFlowLayout = ZoomSelectionFlowLayout()
        layout.scrollDirection = .vertical
        layout.newProposedOffsetAction = { [weak self] indexPath in
            self?.selectedIndex = indexPath.row
        }
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<
        SelectionSection,
        SelectionItem
    > = createDataSource()
    
    var completionAction: PassthroughSubject<Int, Never> = PassthroughSubject<Int, Never>()
    
    var viewList: [SelectionItem]? {
        didSet {
            guard let viewList: [SelectionItem] = viewList else {
                return
            }

            var snapshot: NSDiffableDataSourceSnapshot<
                SelectionSection,
                SelectionItem
            > = NSDiffableDataSourceSnapshot<
                SelectionSection,
                SelectionItem
            >()
            snapshot.appendSections(SelectionSection.allCases)
            snapshot.appendItems(viewList)
            
            dataSource.apply(snapshot)
        }
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<
        SelectionSection,
        SelectionItem
    > {
        let cell: ViewCell = ViewCell { cell, indexPath, itemIdentifier in
            cell.setup(model: itemIdentifier)
        }
        
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: cell,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .darkGray
                
        view.addSubviews(
            titleLabel,
            confirmButton,
            collectionView
        )
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80.0).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80.0).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0).isActive = true
        collectionView.topAnchor.constraint(equalTo: confirmButton.bottomAnchor).isActive = true
    }
    
    private func confirmButtonTapped() {
        completionAction.send(selectedIndex)
    }
}

extension SelectionCellViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width - 60, height: 100)
    }
}

