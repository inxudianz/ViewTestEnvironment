//
//  BaseCollectionSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

class BaseCollectionSectionViewController<T: CollectionType>: BaseSectionViewController {
    // MARK: - Class Getter
    class func getIdentifier() -> String {
        assertionFailure("Implement at child")
        return ""
    }
    
    // MARK: - Property
    lazy var config: CollectionConfig<T> = CollectionConfig(identifier: Self.getIdentifier())
}

