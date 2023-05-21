//
//  +UIEdgeInset.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

extension UIEdgeInsets {
    init(edge: CGFloat) {
        self.init(
            top: edge,
            left: edge,
            bottom: edge,
            right: edge
        )
    }
}
