//
//  Config.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class Config {
    static var availableComponentList: [ComponentItem] {
        [
            ComponentItem(
                identifier: "sample-view",
                title: NSAttributedString(
                    string: "Sample View"
                ),
                correspondingViews: [
                    Factory.createSandboxSamplePlaceholder(model: "Placeholder1", color: .blue),
                    Factory.createSandboxSamplePlaceholder(model: "Placeholder2", color: .orange),
                    Factory.createSandboxSamplePlaceholder(model: "Placeholder3", color: .yellow),
                    Factory.createSandboxSamplePlaceholder(model: "Placeholder4", color: .green),
                    Factory.createSandboxSamplePlaceholder(model: "Placeholder5", color: .gray),
                    Factory.createSandboxSamplePlaceholder(model: "Placeholder6", color: .red)
                ]
            )
        ]
    }
}
