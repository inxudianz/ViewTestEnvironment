//
//  CollectionConfig+TypeTable.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// MARK: - CollectionConfig - CollectionTypeTable
extension CollectionConfig where Type == CollectionTypeTable {
    typealias TableDiffable = UITableViewDiffableDataSource<
        CollectionSection,
        CollectionItem
    >
    
    func createDataSource(tableView: inout UITableView) -> TableDiffable {
        UITableViewDiffableDataSource(
            tableView: tableView
        ) { [weak self] tableView, indexPath, itemIdentifier in
            guard let cell: CollectionTableCell = tableView.dequeueReusableCell(
                withIdentifier: self?.identifier ?? "",
                for: indexPath
            ) as? CollectionTableCell else {
                return UITableViewCell()
            }
            
            cell.setup(model: itemIdentifier)
            cell.minWidth = tableView.frame.width
            cell.maxHeight = tableView.frame.height
            return cell
        }
    }
    
    func createTable(identifier: String) -> UITableView {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CollectionTableCell.self, forCellReuseIdentifier: identifier)
        return tableView
    }
}
