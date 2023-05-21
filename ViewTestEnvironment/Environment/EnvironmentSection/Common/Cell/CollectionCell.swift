//
//  CollectionCell.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// MARK: - UICollectionViewCell
final class CollectionCell: UICollectionViewCell {
    var maxWidth: CGFloat? {
        didSet {
            guard let maxWidth: CGFloat = maxWidth else {
                return
            }
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        }
    }
    
    var minWidth: CGFloat? {
        didSet {
            guard let minWidth: CGFloat = minWidth else {
                return
            }
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.widthAnchor.constraint(equalToConstant: minWidth).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        addSubview(contentView, constraintToEdges: true)
    }
}
