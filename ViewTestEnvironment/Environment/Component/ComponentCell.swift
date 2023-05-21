//
//  ComponentCell.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// MARK: - Cell
final class ComponentCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
    
    var maxWidth: CGFloat? {
        didSet {
            guard let maxWidth: CGFloat = maxWidth else {
                return
            }
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(model: ComponentItem) {
        titleLabel.attributedText = model.title
        titleLabel.textAlignment = .center
    }
    
    private func constructView() {
        constraintToEdges(of: contentView)
        contentView.addSubviews(
            titleLabel
        )
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.constraintToEdges(of: titleLabel, inset: .init(edge: 12.0))
        
        backgroundColor = .lightGray
        layer.cornerRadius = 16.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
}
