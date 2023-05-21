//
//  CollectionItem.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// MARK: - Collection Object
struct CollectionItem: Hashable {
    let id: UUID = UUID()
    let view: UIView
}
