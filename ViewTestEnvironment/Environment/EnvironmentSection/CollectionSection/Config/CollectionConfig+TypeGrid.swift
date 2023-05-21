//
//  CollectionConfig+TypeGrid.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// MARK: - CollectionConfig - CollectionTypeGrid
extension CollectionConfig where Type == CollectionTypeGrid {
    typealias ViewCell = UICollectionView.CellRegistration<
        CollectionCell,
        CollectionItem
    >
    typealias CollectionDiffable = UICollectionViewDiffableDataSource<
        CollectionSection,
        CollectionItem
    >
    
    func createDataSource(collectionView: inout UICollectionView, isMaxWidth: Bool = true) -> CollectionDiffable {
        let cell: ViewCell = createRegisteredCell(collectionView: collectionView, isMaxWidth: isMaxWidth)
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
    
    func createCollection(layout: UICollectionViewLayout, identifier: String) -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    private func createRegisteredCell(
        collectionView: UICollectionView,
        isMaxWidth: Bool
    ) -> ViewCell {
        ViewCell { cell, indexPath, itemIdentifier in
            cell.setup(model: itemIdentifier)
            if isMaxWidth {
                cell.maxWidth = collectionView.frame.width
            }
            else {
                cell.minWidth = collectionView.frame.width
            }
        }
    }
}

