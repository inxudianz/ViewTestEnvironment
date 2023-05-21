//
//  StackViewSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class StackViewSectionViewController: BaseSectionViewController {
    private enum Distribution: String, CaseIterable {
        case fill
        case fillEqually
        case fillProportionally
        case equalSpacing
        case equalCentering
        
        init?(index: Int) {
            let expectedValue: String? = Self.allCases.enumerated().first { enumIndex, value in
                enumIndex == index
            }?.element.rawValue
            
            self.init(rawValue: expectedValue ?? "")
        }
    }
    
    // MARK: - Property
    private var itemCount: Int = 1 {
        didSet {
            if oldValue > itemCount {
                guard assignedViews?.count ?? .zero >= itemCount else {
                    return
                }
                
                viewList?.removeLast()
            }
            else {
                guard assignedViews?.count ?? .zero >= itemCount else {
                    itemCountStepper.value = Double(oldValue)
                    return
                }
                
                viewList?.append(CollectionItem(view: assignedViews?[itemCount - 1] ?? UIView()))
            }
            itemCountLabel.text = "Item Count:\(itemCount)"
        }
    }
    
    private var viewList: [CollectionItem]? {
        didSet {
            guard viewList != nil else {
                return
            }
            
            resetSection()
        }
    }
    
    private var isVertical: Bool = true {
        didSet {
            stackView.axis = isVertical ? .vertical : .horizontal
            resetSection()
        }
    }
    
    private var distributionType: Int = .zero {
        didSet {
            stackView.distribution = UIStackView.Distribution(rawValue: distributionType) ?? .fill
            distributionLabel.text = "Distribution Style:\(Distribution(index: distributionType)?.rawValue ?? "")"
            resetSection()
        }
    }
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
    
    private lazy var distributionStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 0
        view.maximumValue = 4
        view.stepValue = 1
        view.addAction(.init(handler: { [weak self] _ in
            self?.distributionType = Int(view.value)
        }), for: .valueChanged)
        
        return view
    }()
    
    private lazy var itemCountStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 1
        view.maximumValue = Double(assignedViews?.count ?? 1)
        view.stepValue = 1
        view.addAction(.init(handler: { [weak self] _ in
            self?.itemCount = Int(view.value)
        }), for: .valueChanged)
        
        return view
    }()
    
    private lazy var verticalToggle: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("is Vertical: \(isVertical)", for: .normal)
        button.addAction(.init(handler: { [weak self] _ in
            self?.buttonToggleTapped()
        }), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private lazy var configStackView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.axis = .vertical
        view.spacing = 8.0
        view.distribution = .fillEqually
        
        return view
    }()
    
    private lazy var itemCountLabel: UILabel = {
        let itemCountLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
        itemCountLabel.text = "Item Count:\(itemCount)"
        
        return itemCountLabel
    }()

    private lazy var distributionLabel: UILabel = {
        let distributionLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
        distributionLabel.text = "Distribution Style:\(Distribution(index: distributionType)?.rawValue ?? "")"
        return distributionLabel
    }()
    
    private lazy var configContainer: UIView = {
        let view: UIView = UIView()

        view.addSubview(configStackView, constraintToEdges: true)
        [
            itemCountLabel,
            itemCountStepper,
            distributionLabel,
            distributionStepper,
            verticalToggle
        ].forEach({ configStackView.addArrangedSubview($0) })
        
        return view
    }()
    
    private lazy var stackContainer: UIView = {
        UIView()
    }()
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard assignedViews != nil else {
            return
        }
        
        stackContainer.addSubview(scrollView, constraintToEdges: true)
        viewList = [CollectionItem(view: assignedViews?.first ?? UIView())]
        scrollView.constraintToEdges(of: stackContainer, isSafeArea: true)
        
        scrollView.addSubview(stackView)
        
        stackView.constraintToEdges(of: scrollView)
        stackView.widthAnchor.constraint(greaterThanOrEqualTo:scrollView.widthAnchor).isActive = true
        
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        resetSection()
    }
    
    private func resetSection() {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        viewList?.forEach({ stackView.addArrangedSubview($0.view) })
        
        addSections(
            views: configContainer,
            stackContainer
        )
    }
    
    private func buttonToggleTapped() {
        isVertical.toggle()
        verticalToggle.setTitle("is Vertical: \(isVertical)", for: .normal)
    }
}
