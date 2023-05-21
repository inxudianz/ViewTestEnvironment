//
//  CollectionTableCell.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// MARK: - UITableViewCell
final class CollectionTableCell: UITableViewCell {
    var minWidth: CGFloat? {
        didSet {
            guard let minWidth: CGFloat = minWidth else {
                return
            }
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.widthAnchor.constraint(equalToConstant: minWidth).isActive = true
        }
    }
    
    var maxHeight: CGFloat? {
        didSet {
            guard let maxHeight: CGFloat = maxHeight else {
                return
            }
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        constructView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(model: CollectionItem) {
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        contentView.addSubview(model.view, constraintToEdges: true)
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    func constructView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
