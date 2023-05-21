//
//  Config+Component.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

extension Config {
    final class Factory {
        static func createSandboxSamplePlaceholder(model: String, color: UIColor) -> PlaceholderView {
            let view: PlaceholderView = PlaceholderView()
            view.setupView(with: model, color: color)
            return view
        }
    }
}
