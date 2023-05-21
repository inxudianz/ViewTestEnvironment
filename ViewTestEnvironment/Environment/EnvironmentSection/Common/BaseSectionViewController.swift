//
//  BaseSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

class BaseSectionViewController: UIViewController {
    var assignedViews: [UIView]?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.backgroundColor = .white
        
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.distribution = .fill
        stackView.layoutMargins = .zero
        stackView.isLayoutMarginsRelativeArrangement = true

        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.constraintToEdges(of: view)
        
        scrollView.addSubview(stackView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTapped)))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.constraintToEdges(of: scrollView)
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    // MARK: - Method
    func addSections(views: UIView...) {
        stackView.subviews.forEach({ $0.removeFromSuperview() })
        
        views.forEach { view in
            let container: UIView = UIView()
            container.addSubview(view, constraintToEdges: true)
            stackView.addArrangedSubview(container)
            stackView.setCustomSpacing(4.0, after: container)
        }
    }
    
    // MARK: - Private Method
    @objc
    private func viewDidTapped() {
        view.endEditing(true)
    }
}
