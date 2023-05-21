//
//  ConstraintSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class ConstraintSectionViewController: BaseSectionViewController {
    // MARK: - Property
    private var itemCount: Int = .zero {
        didSet {
            if oldValue > itemCount {
                guard assignedViews?.count ?? .zero > itemCount else {
                    return
                }
                selectedView = assignedViews?[itemCount]
            }
            else {
                guard assignedViews?.count ?? .zero > itemCount else {
                    itemCountStepper.value = Double(oldValue) + 1
                    return
                }
                selectedView = assignedViews?[itemCount]
            }
        }
    }
    
    private var selectedView: UIView? {
        didSet {
            forceConstraintContainer.subviews.forEach({ $0.removeFromSuperview() })
            leadingConstraint?.isActive = false
            topConstraint?.isActive = false
            trailingConstraint?.isActive = false
            botConstraint?.isActive = false
            
            selectedLabel.text = "Selected View:\(assignedViews?.firstIndex(where: { $0 === selectedView }) ?? .zero + 1)"
            setupSelectedView()
        }
    }
    
    private var currentLeading: Int = 0 {
        didSet {
            leadingLabel.text = "Leading:\(currentLeading)"
            leadingConstraint?.constant = CGFloat(currentLeading)
        }
    }
    
    private var currentTop: Int = 0 {
        didSet {
            topLabel.text = "Top:\(currentTop)"
            topConstraint?.constant = CGFloat(currentTop)
        }
    }
    
    private var currentTrailing: Int = 0 {
        didSet {
            trailingLabel.text = "Trailing:\(currentTrailing)"
            trailingConstraint?.constant = CGFloat(currentTrailing)
        }
    }
    
    private var currentBot: Int = 0 {
        didSet {
            botLabel.text = "Bot:\(currentBot)"
            botConstraint?.constant = CGFloat(currentBot)
        }
    }
    
    private var leadingConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var botConstraint: NSLayoutConstraint?

    private lazy var itemCountStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 1
        view.maximumValue = Double(assignedViews?.count ?? 1)
        view.stepValue = 1
        view.addAction(.init(handler: { [weak self] _ in
            self?.itemCount = Int(view.value) - 1
        }), for: .valueChanged)
        
        return view
    }()
    
    private lazy var leadingStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = -500
        view.maximumValue = 500
        view.stepValue = 10
        view.value = Double(currentLeading)
        view.addAction(.init(handler: { [weak self] _ in
            self?.currentLeading = Int(view.value)
        }), for: .valueChanged)
        
        return view
    }()
    
    private lazy var topStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = -500
        view.maximumValue = 500
        view.stepValue = 10
        view.value = Double(currentTop)
        view.addAction(.init(handler: { [weak self] _ in
            self?.currentTop = Int(view.value)
        }), for: .valueChanged)
        
        return view
    }()
    
    private lazy var trailingStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = -500
        view.maximumValue = 500
        view.stepValue = 10
        view.value = Double(currentTrailing)
        view.addAction(.init(handler: { [weak self] _ in
            self?.currentTrailing = Int(view.value)
        }), for: .valueChanged)
        
        return view
    }()
    
    private lazy var botStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = -500
        view.maximumValue = 500
        view.stepValue = 10
        view.value = Double(currentBot)
        view.addAction(.init(handler: { [weak self] _ in
            self?.currentBot = Int(view.value)
        }), for: .valueChanged)
        
        return view
    }()
    
    private lazy var configStackView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.axis = .vertical
        view.spacing = 8.0
        view.distribution = .fillEqually
        
        return view
    }()
    
    private lazy var leadingLabel: UILabel = {
        let leadingLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .body), color: .black)
        leadingLabel.text = "Leading:\(currentLeading)"
        
        return leadingLabel
    }()
    
    private lazy var topLabel: UILabel = {
        let topLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .body), color: .black)
        topLabel.text = "Top:\(currentTop)"
        
        return topLabel
    }()
    
    private lazy var trailingLabel: UILabel = {
        let trailingLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .body), color: .black)
        trailingLabel.text = "Trailing:\(currentTrailing)"
        return trailingLabel
    }()
    
    private lazy var botLabel: UILabel = {
        let botLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .body), color: .black)
        botLabel.text = "Bot:\(currentBot)"
        return botLabel
    }()
    
    private lazy var selectedLabel: UILabel = {
        let selectedLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
        selectedLabel.text = "Selected View:\(assignedViews?.firstIndex(where: { $0 === selectedView }) ?? .zero)"
        
        return selectedLabel
    }()
    
    private lazy var configContainer: UIView = {
        let view: UIView = UIView()
        
        view.addSubview(configStackView, constraintToEdges: true)
        [
            leadingLabel,
            leadingStepper,
            topLabel,
            topStepper,
            trailingLabel,
            trailingStepper,
            botLabel,
            botStepper,
            selectedLabel,
            itemCountStepper
        ].forEach({ configStackView.addArrangedSubview($0) })
        
        return view
    }()
    
    private lazy var forceConstraintContainer: UIView = UIView()
    
    // MARK: - Override
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard assignedViews != nil else {
            return
        }
        
        selectedView = assignedViews?.first
        addSections(
            views: configContainer,
            forceConstraintContainer
        )
    }
    
    private func setupSelectedView() {
        guard let assignedView: UIView = selectedView else {
            return
        }
        
        forceConstraintContainer.addSubview(assignedView)
        
        assignedView.translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint = assignedView.leadingAnchor.constraint(equalTo: forceConstraintContainer.leadingAnchor, constant: CGFloat(currentLeading))
        leadingConstraint?.isActive = true

        topConstraint = assignedView.topAnchor.constraint(equalTo: forceConstraintContainer.topAnchor, constant: CGFloat(currentTop))
        topConstraint?.isActive = true
        
        trailingConstraint = assignedView.trailingAnchor.constraint(equalTo: forceConstraintContainer.trailingAnchor, constant: CGFloat(currentTrailing))
        trailingConstraint?.isActive = true
        
        botConstraint = assignedView.bottomAnchor.constraint(equalTo: forceConstraintContainer.bottomAnchor, constant: CGFloat(currentBot))
        botConstraint?.isActive = true

    }
}
