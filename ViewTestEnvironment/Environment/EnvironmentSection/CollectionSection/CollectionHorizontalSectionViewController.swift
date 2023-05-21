//
//  CollectionHorizontalSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class CollectionHorizontalSectionViewController: BaseCollectionSectionViewController<CollectionTypeGrid> {
    // MARK: -  Override
    override class func getIdentifier() -> String {
        "horizontal-cell"
    }
    
    // MARK: - Property
    private lazy var horizontalDataSource = config.createDataSource(collectionView: &collectionHorizontalView)
    
    private var horizontalItemCount: Int = 1 {
        didSet {
            if oldValue > horizontalItemCount {
                guard assignedViews?.count ?? .zero >= horizontalItemCount else {
                    return
                }
                
                horizontalViewList?.removeLast()
            }
            else {
                guard assignedViews?.count ?? .zero >= horizontalItemCount else {
                    collectionHorizontalStepper.value = Double(oldValue)
                    return
                }
                
                horizontalViewList?.append(CollectionItem(view: assignedViews?[horizontalItemCount - 1] ?? UIView()))
            }
            collectionHorizontalLabel.text = "Cell Count:\(horizontalItemCount)"
        }
    }
    
    private var horizontalViewList: [CollectionItem]? {
        didSet {
            guard let horizontalViewList: [CollectionItem] = horizontalViewList else {
                return
            }
            horizontalDataSource.apply(config.createSnapshot(items: horizontalViewList))
        }
    }
    
    private var currentHeight: Int = 100 {
        didSet {
            collectionHeightLabel.text = "Cell Height:\(currentHeight)"
            collectionHorizontalHeightConstraint?.constant = CGFloat(currentHeight)
        }
    }
    
    private var collectionHorizontalHeightConstraint: NSLayoutConstraint?

    private lazy var collectionHorizontalLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private lazy var collectionHorizontalView: UICollectionView = config.createCollection(layout: collectionHorizontalLayout, identifier: Self.getIdentifier())

    private lazy var collectionHorizontalStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 1
        view.maximumValue = Double(assignedViews?.count ?? 1)
        view.stepValue = 1
        view.addAction(.init(handler: { [weak self] _ in
            if (self?.assignedViews?.count ?? .zero) - Int(view.value) < .zero {
                view.stepValue = Double(self?.horizontalItemCount ?? .zero)
            }
            else {
                self?.horizontalItemCount = Int(view.value)
            }
        }), for: .valueChanged)
        return view
    }()
    
    private lazy var collectionHeightStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 100
        view.maximumValue = 1000
        view.stepValue = 50
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
    
    private lazy var collectionHorizontalLabel: UILabel = {
        let collectionHorizontalLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
        collectionHorizontalLabel.text = "Cell Count:\(horizontalItemCount)"
        
        return collectionHorizontalLabel
    }()
    
    private lazy var collectionHeightLabel: UILabel = {
        let collectionHeightLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
        collectionHeightLabel.text = "Cell Height:\(currentHeight)"

        return collectionHeightLabel
    }()
    
    private lazy var configContainer: UIView = {
        let view: UIView = UIView()

        view.addSubview(configStackView, constraintToEdges: true)
        [
            collectionHorizontalLabel,
            collectionHorizontalStepper,
            collectionHeightLabel,
            collectionHeightStepper
        ].forEach({ configStackView.addArrangedSubview($0) })
        
        return view
    }()
    
    
    private lazy var collectionHorizontalContainer: UIView = {
        guard let assignedView: UIView = assignedViews?.first else {
            return UIView()
        }
        
        let view: UIView = UIView()
        horizontalViewList = [CollectionItem(view: assignedView)]
        
        view.addSubview(collectionHorizontalView, constraintToEdges: true)

        collectionHorizontalView.translatesAutoresizingMaskIntoConstraints = false
        collectionHorizontalHeightConstraint = collectionHorizontalView.heightAnchor.constraint(equalToConstant: 100.0)
        collectionHorizontalHeightConstraint?.isActive = true

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
            collectionHorizontalContainer
        )
    }
}
