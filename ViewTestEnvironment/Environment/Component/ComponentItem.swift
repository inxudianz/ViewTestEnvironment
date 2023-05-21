//
//  ComponentItem.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import Foundation
import UIKit

// MARK: - Item
struct ComponentItem: Hashable {
    var identifier: String
    var title: NSAttributedString
    
    var correspondingViews: [UIView]
}
