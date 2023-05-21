//
//  Config+Selection.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import Foundation

extension Config {
    enum SelectionItemIdentifier: String, CaseIterable {
        case empty
        case constraint
        case size
        case collectionVertical
        case collectionHorizontal
        case collectionDynamic
        case collectionComposition
        case table
        case stack
        
        func titleIdentifier() -> String {
            switch self {
            default: return rawValue.capitalized
            }
        }
    }
    
    static var selectionList: [SelectionItem] {
        SelectionItemIdentifier.allCases.map({ SelectionItem(identifier: $0) })
    }
}
