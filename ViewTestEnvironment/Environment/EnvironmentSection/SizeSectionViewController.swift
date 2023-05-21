//
//  SizeSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class SizeSectionViewController: BaseSectionViewController {
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
            forceSizeContainer.subviews.forEach({ $0.removeFromSuperview() })
            widthConstraint?.isActive = false
            heightConstraint?.isActive = false
            
            selectedLabel.text = "Selected View:\(assignedViews?.firstIndex(where: { $0 === selectedView }) ?? .zero + 1)"
            setupSelectedView()
        }
    }
    
    private var currentWidth: Int = 300 {
        didSet {
            widthConstraint?.constant = CGFloat(currentWidth)
            widthLabel.text = "Width:\(currentWidth)"
        }
    }
    
    private var currentHeight: Int = 300 {
        didSet {
            heightConstraint?.constant = CGFloat(currentHeight)
            heightLabel.text = "Height:\(currentHeight)"
        }
    }
    
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
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
    
    private lazy var widthStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 0
        view.maximumValue = 2000
        view.stepValue = 50
        view.value = Double(currentWidth)
        view.addAction(.init(handler: { [weak self] _ in
            self?.currentWidth = Int(view.value)
        }), for: .valueChanged)
        
        return view
    }()
    
    private lazy var heightStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 0
        view.maximumValue = 2000
        view.stepValue = 50
        view.value = Double(currentHeight)
        view.addAction(.init(handler: { [weak self] _ in
            self?.currentHeight = Int(view.value)
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
    
    private lazy var widthLabel: UILabel = {
        let widthLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .callout), color: .black)
        widthLabel.text = "Width:\(currentWidth)"
        
        return widthLabel
    }()
    
    private lazy var heightLabel: UILabel = {
        let heightLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .callout), color: .black)
        heightLabel.text = "Height:\(currentHeight)"
        
        return heightLabel
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
            widthLabel,
            widthStepper,
            heightLabel,
            heightStepper,
            selectedLabel,
            itemCountStepper
        ].forEach({ configStackView.addArrangedSubview($0) })

        return view
    }()
    
    private lazy var forceSizeContainer: UIView = UIView()
    
    // MARK: - Override
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard assignedViews != nil else {
            return
        }
        
        selectedView = assignedViews?.first
        addSections(
            views: configContainer,
            forceSizeContainer
        )
    }
    
    private func setupSelectedView() {
        guard let assignedView: UIView = selectedView else {
            return
        }
        
        forceSizeContainer.addSubview(assignedView)
        
        assignedView.translatesAutoresizingMaskIntoConstraints = false
        assignedView.leadingAnchor.constraint(equalTo: forceSizeContainer.leadingAnchor).isActive = true
        assignedView.topAnchor.constraint(equalTo: forceSizeContainer.topAnchor).isActive = true
        assignedView.bottomAnchor.constraint(equalTo: forceSizeContainer.bottomAnchor).isActive = true
        assignedView.trailingAnchor.constraint(lessThanOrEqualTo: forceSizeContainer.trailingAnchor).isActive = true
        widthConstraint = assignedView.widthAnchor.constraint(equalToConstant: CGFloat(currentWidth))
        widthConstraint?.isActive = true
        heightConstraint = assignedView.heightAnchor.constraint(equalToConstant: CGFloat(currentHeight))
        heightConstraint?.isActive = true
    }
}
