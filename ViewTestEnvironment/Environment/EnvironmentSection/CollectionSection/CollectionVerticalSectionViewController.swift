//
//  CollectionVerticalSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class CollectionVerticalSectionViewController: BaseCollectionSectionViewController<CollectionTypeGrid> {
    // MARK: -  Override
    override class func getIdentifier() -> String {
        "vertical-cell"
    }
    
    // MARK: - Property
    private lazy var verticalDataSource = config.createDataSource(
        collectionView: &collectionVerticalView,
        isMaxWidth: false
    )

    private lazy var collectionVerticalLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private var verticalViewList: [CollectionItem]? {
        didSet {
            guard let verticalViewList: [CollectionItem] = verticalViewList else {
                return
            }
            
            verticalDataSource.apply(
                config.createSnapshot(items: verticalViewList),
                animatingDifferences: true
            ) { [weak self] in
                self?.collectionVerticalHeightConstraint?.constant = CGFloat(self?.collectionVerticalView.collectionViewLayout.collectionViewContentSize.height ?? .zero)
            }
        }
    }
    
    private var verticalItemCount: Int = 1 {
        didSet {
            if oldValue > verticalItemCount {
                guard assignedViews?.count ?? .zero >= verticalItemCount else {
                    return
                }
                
                verticalViewList?.removeLast()
            }
            else {
                guard assignedViews?.count ?? .zero >= verticalItemCount else {
                    collectionVerticalStepper.value = Double(oldValue)
                    return
                }
                
                verticalViewList?.append(CollectionItem(view: assignedViews?[verticalItemCount - 1] ?? UIView()))
            }
            
            collectionVerticalLabel.text = "Cell Count:\(verticalItemCount)"
        }
    }
    
    private lazy var collectionVerticalView: UICollectionView = config.createCollection(
        layout: collectionVerticalLayout,
        identifier: Self.getIdentifier()
    )
    
    private lazy var collectionVerticalStepper: UIStepper = {
        let view: UIStepper = UIStepper()
        view.minimumValue = 1
        view.maximumValue = Double(assignedViews?.count ?? 1)
        view.stepValue = 1
        view.addAction(.init(handler: { [weak self] _ in
            if (self?.assignedViews?.count ?? .zero) - Int(view.value) < .zero {
                view.stepValue = Double(self?.verticalItemCount ?? .zero)
            }
            else {
                self?.verticalItemCount = Int(view.value)
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
    
    private lazy var collectionVerticalLabel: UILabel = {
        let collectionVerticalLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title3), color: .black)
        collectionVerticalLabel.text = "Cell Count:\(verticalItemCount)"
        
        return collectionVerticalLabel
    }()
    
    private lazy var configContainer: UIView = {
        let view: UIView = UIView()
                
        view.addSubview(configStackView, constraintToEdges: true)
        [
            collectionVerticalLabel,
            collectionVerticalStepper
        ].forEach({ configStackView.addArrangedSubview($0) })

        return view
    }()
    
    private lazy var collectionVerticalContainer: UIView = {
        guard let assignedView: UIView = assignedViews?.first else {
            return UIView()
        }
        
        let view: UIView = UIView()
        verticalViewList = [CollectionItem(view: assignedView)]
        view.addSubview(collectionVerticalView, constraintToEdges: true)
        
        collectionVerticalView.translatesAutoresizingMaskIntoConstraints = false
        collectionVerticalHeightConstraint = collectionVerticalView.heightAnchor.constraint(equalToConstant: 100.0)
        collectionVerticalHeightConstraint?.isActive = true

        return view
    }()
    
    private var collectionVerticalHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard assignedViews != nil else {
            return
        }
        
        addSections(
            views: configContainer,
            collectionVerticalContainer
        )
    }
}
