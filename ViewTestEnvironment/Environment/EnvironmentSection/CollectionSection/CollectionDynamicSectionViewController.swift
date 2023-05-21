//
//  CollectionDynamicSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class CollectionDynamicSectionViewController: BaseCollectionSectionViewController<CollectionTypeGrid> {
    // MARK: -  Override
    override class func getIdentifier() -> String {
        "dynamic-cell"
    }
    
    // MARK: - Property
    private lazy var dynamicDataSource = config.createDataSource(collectionView: &collectionDynamicView)

    private var dynamicItemCount: Int = 1 {
        didSet {
            if oldValue > dynamicItemCount {
                guard assignedViews?.count ?? .zero >= dynamicItemCount else {
                    return
                }
                
                dynamicViewList?.removeLast()
            }
            else {
                guard assignedViews?.count ?? .zero >= dynamicItemCount else {
                    collectionDynamicStepper.stepValue = Double(oldValue)
                    return
                }
                
                dynamicViewList?.append(CollectionItem(view: assignedViews?[dynamicItemCount - 1] ?? UIView()))
            }
            collectionDynamicLabel.text = "Cell Count:\(dynamicItemCount)"
        }
    }
    
    private var dynamicViewList: [CollectionItem]? {
        didSet {
            guard let dynamicViewList: [CollectionItem] = dynamicViewList else {
                return
            }
            
            dynamicDataSource.apply(
                config.createSnapshot(items: dynamicViewList),
                animatingDifferences: true
            ) { [weak self] in
                let highestHeight: Int = Int(dynamicViewList.sorted(by: { $0.view.frame.height > $1.view.frame.height }).first?.view.frame.height ?? 100.0)
                self?.collectionDynamicHeightConstraint?.constant = CGFloat(highestHeight + 20)
            }
        }
    }
    
    private var collectionDynamicHeightConstraint: NSLayoutConstraint?
    
    private lazy var collectionDynamicLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private lazy var collectionDynamicView: UICollectionView = config.createCollection(
        layout: collectionDynamicLayout,
        identifier: Self.getIdentifier()
    )

    private lazy var collectionDynamicStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 1
        view.maximumValue = Double(assignedViews?.count ?? 1)
        view.stepValue = 1
        view.addAction(.init(handler: { [weak self] _ in
            if (self?.assignedViews?.count ?? .zero) - Int(view.value) < .zero {
                view.stepValue = Double(self?.dynamicItemCount ?? .zero)
            }
            else {
                self?.dynamicItemCount = Int(view.value)
            }
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
    
    private lazy var collectionDynamicLabel: UILabel = {
        let collectionDynamicLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
        collectionDynamicLabel.text = "Cell Count:\(dynamicItemCount)"
        
        return collectionDynamicLabel
    }()
    
    private lazy var configContainer: UIView = {
        let view: UIView = UIView()

        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reload Collection", for: .normal)
        button.addAction(.init(handler: { [weak self] _ in
            self?.buttonDidTapped()
        }), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        view.addSubview(configStackView, constraintToEdges: true)
        
        [
            collectionDynamicLabel,
            collectionDynamicStepper,
            button
        ].forEach({ configStackView.addArrangedSubview($0) })
        
        return view
    }()
    
    private lazy var collectionDynamicContainer: UIView = {
        guard let assignedView: UIView = assignedViews?.first else {
            return UIView()
        }
        
        let view: UIView = UIView()
        dynamicViewList = [CollectionItem(view: assignedView)]
        
        view.addSubview(collectionDynamicView, constraintToEdges: true)

        collectionDynamicView.translatesAutoresizingMaskIntoConstraints = false
        collectionDynamicHeightConstraint = collectionDynamicView.heightAnchor.constraint(equalToConstant: 100.0)
        collectionDynamicHeightConstraint?.isActive = true

        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard assignedViews != nil else {
            return
        }
        
        addSections(
            views: configContainer,
            collectionDynamicContainer
        )
    }
    
    // MARK: - Selector
    private func buttonDidTapped() {
        dynamicDataSource.apply(
            dynamicDataSource.snapshot(),
            animatingDifferences: true
        ) { [weak self] in
            let highestHeight: Int = Int(self?.dynamicViewList?.sorted(by: { $0.view.frame.height > $1.view.frame.height }).first?.view.frame.height ?? 100.0)
            self?.collectionDynamicHeightConstraint?.constant = CGFloat(highestHeight + 20)
        }
    }
}
