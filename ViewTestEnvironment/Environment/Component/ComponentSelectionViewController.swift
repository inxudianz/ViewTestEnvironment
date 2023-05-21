//
//  ComponentSelectionViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import Combine
import UIKit

final class ComponentSelectionViewController: UIViewController {
    // MARK: - Constant
    private static let cellReuseID: String = "component-cell"
    
    // MARK: - Alias
    private typealias ViewCell = UICollectionView.CellRegistration<
        ComponentCell,
        ComponentItem
    >
    
    // MARK: - Property
    var selectionChoice: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
    
    var viewList: [ComponentItem]? {
        didSet {
            filteredViewList = viewList
        }
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<
        ComponentSection,
        ComponentItem
    > = createDataSource()
    
    private var query: String = "" {
        didSet {
            if query.isEmpty {
                filteredViewList = viewList
            }
            else {
                filteredViewList = viewList?.filter({ $0.title.string.contains(query) })
            }
        }
    }
    
    private var filteredViewList: [ComponentItem]? {
        didSet {
            guard var filteredViewList: [ComponentItem] = filteredViewList else {
                return
            }
            
            for (index, filterView) in filteredViewList.enumerated() {
                let attributedTitle: NSMutableAttributedString =
                NSMutableAttributedString(string: filterView.title.string)
                attributedTitle.addAttributes(
                    [
                        .font: UIFont.preferredFont(forTextStyle: .title3),
                        .foregroundColor: UIColor.black
                    ],
                    range: NSRangeFromString(filterView.title.string)
                )
                
                let range: NSRange = attributedTitle.mutableString.range(
                    of: query,
                    options: .caseInsensitive
                )
                
                if range.length > .zero  {
                    attributedTitle.addAttribute(
                        .foregroundColor,
                        value: UIColor.purple,
                        range: range
                    )
                }
                
                filteredViewList[index].title = attributedTitle
            }
            
            var snapshot: NSDiffableDataSourceSnapshot<
                ComponentSection,
                ComponentItem
            > = NSDiffableDataSourceSnapshot<
                ComponentSection,
                ComponentItem
            >()
            
            snapshot.appendSections(ComponentSection.allCases)
            snapshot.appendItems(filteredViewList)
            
            dataSource.apply(snapshot)
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Search available view"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        return searchBar
    }()
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 20.0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionLayout
        )
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Method
    private func createDataSource() -> UICollectionViewDiffableDataSource<
        ComponentSection,
        ComponentItem
    > {
        let cell: ViewCell = ViewCell { cell, indexPath, itemIdentifier in
            cell.setup(model: itemIdentifier)
            cell.maxWidth = self.collectionView.frame.width - 100
        }
        
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: cell,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubviews(
            searchBar,
            collectionView
        )
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
    }
}

extension ComponentSelectionViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        query = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
}

extension ComponentSelectionViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        dismiss(animated: true) { [weak self] in
            self?.selectionChoice.send(self?.viewList?[indexPath.row].identifier ?? "")
        }
    }
}

