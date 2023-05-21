//
//  SelectionCell.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// MARK: - Cell
final class SelectionCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title2), color: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(model: SelectionItem) {
        titleLabel.text = model.identifier.titleIdentifier()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = .zero
        titleLabel.textColor = .white
    }
    
    private func constructView() {
        constraintToEdges(of: contentView)
        contentView.addSubviews(
            titleLabel
        )
        
        titleLabel.constraintToEdges(of: contentView, inset: .init(edge: 10.0))
        
        backgroundColor = .purple
        layer.cornerRadius = 16.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
}
