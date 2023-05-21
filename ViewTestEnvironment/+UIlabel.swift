//
//  +UIlabel.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

extension UILabel {
    convenience init(
        font: UIFont,
        color: UIColor
    ) {
        self.init()
        self.font = font
        self.textColor = color
    }
}
