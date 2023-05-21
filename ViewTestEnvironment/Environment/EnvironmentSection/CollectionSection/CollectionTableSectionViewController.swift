//
//  CollectionTableSectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class CollectionTableSectionViewController: BaseCollectionSectionViewController<CollectionTypeTable> {
    // MARK: -  Override
    override class func getIdentifier() -> String {
        "table-cell"
    }

    // MARK: - Property
    private var verticalViewList: [CollectionItem]? {
        didSet {
            guard let verticalViewList: [CollectionItem] = verticalViewList else {
                return
            }
            
            dataSource.apply(
                config.createSnapshot(items: verticalViewList),
                animatingDifferences: true
            ) { [weak self] in
                self?.tableHeightConstraint?.constant = CGFloat(self?.tableView.contentSize.height ?? .zero)
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
                    tableStepper.value = Double(oldValue)
                    return
                }
                
                verticalViewList?.append(CollectionItem(view: assignedViews?[verticalItemCount - 1] ?? UIView()))
            }
            tableLabel.text = "Item Count:\(verticalItemCount)"
        }
    }
    
    private var tableHeightConstraint: NSLayoutConstraint?

    private lazy var dataSource = config.createDataSource(tableView: &tableView)
    
    private lazy var tableView: UITableView = config.createTable(identifier: Self.getIdentifier())
    
    private lazy var tableStepper: UIStepper = {
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
    
    private lazy var tableLabel: UILabel = {
        
        let tableLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
        tableLabel.text = "Item Count:\(verticalItemCount)"
        
        return tableLabel
    }()
    
    private lazy var configContainer: UIView = {
        let view: UIView = UIView()

        view.addSubview(configStackView, constraintToEdges: true)
        [
            tableLabel,
            tableStepper
        ].forEach({ configStackView.addArrangedSubview($0) })
        
        return view
    }()
    
    private lazy var tableContainer: UIView = {
        guard let assignedView: UIView = assignedViews?.first else {
            return UIView()
        }
        
        let view: UIView = UIView()
        verticalViewList = [CollectionItem(view: assignedView)]
        view.addSubview(tableView, constraintToEdges: true)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 100.0)
        tableHeightConstraint?.isActive = true
        
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
            tableContainer
        )
    }
}
