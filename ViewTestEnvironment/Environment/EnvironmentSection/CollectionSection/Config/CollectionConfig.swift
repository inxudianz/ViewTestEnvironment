//
//  CollectionConfig.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// MARK: - Phantom Type
protocol CollectionType {}

enum CollectionTypeGrid: CollectionType {}
enum CollectionTypeTable: CollectionType {}

final class CollectionConfig<Type: CollectionType> {
    let identifier: String
        
    typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<CollectionSection, CollectionItem>

    init(identifier: String) {
        self.identifier = identifier
    }
    
    func createSnapshot(items: [CollectionItem]) -> DiffableSnapshot {
        var snapshot: DiffableSnapshot = DiffableSnapshot()
        snapshot.appendSections(CollectionSection.allCases)
        snapshot.appendItems(items)
        return snapshot
    }
}
