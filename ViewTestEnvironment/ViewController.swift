//
//  ViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.pushViewController(EnvironmentViewController(), animated: true)
    }
}

