//
//  PlaceholderView.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

final class PlaceholderView: UIView  {
    // MARK: - Property
    private var widthValue: CGFloat = 10.0
    private var heightValue: CGFloat = 10.0
    
    private var leadingConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    private lazy var label: UILabel = UILabel(font: .preferredFont(forTextStyle: .title3), color: .black)
    
    private lazy var widthLabel: UILabel = {
        let widthLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .caption1), color: .darkGray)
        
        widthLabel.text = "increase width"
        widthLabel.isUserInteractionEnabled = true
        widthLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(increaseWidth)))
        
        return widthLabel
    }()
    
    private lazy var heightLabel: UILabel = {
        let heightLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .caption1), color: .darkGray)
        heightLabel.text = "increase height"
        heightLabel.isUserInteractionEnabled = true
        heightLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(increaseHeight)))
        
        return heightLabel
    }()
    
    // MARK: - Method
    func setupView(with title: String, color: UIColor) {
        backgroundColor = color
        label.text = title
        
        addSubviews(
            label,
            widthLabel,
            heightLabel
        )
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        widthLabel.translatesAutoresizingMaskIntoConstraints = false
        widthLabel.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        widthLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        leadingConstraint = widthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: widthValue)
        leadingConstraint?.isActive = true
        
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.topAnchor.constraint(equalTo: widthLabel.bottomAnchor).isActive = true
        heightLabel.centerXAnchor.constraint(equalTo: widthLabel.centerXAnchor).isActive = true
        
        bottomConstraint = heightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -heightValue)
        bottomConstraint?.isActive = true
    }
    
    private func setWidthHeightLabel() {
        leadingConstraint?.constant = self.widthValue
        bottomConstraint?.constant = -self.heightValue
    }
    
    @objc
    private func increaseWidth() {
        self.widthValue +=  10.0
        setWidthHeightLabel()
    }
    
    @objc
    private func increaseHeight() {
        self.heightValue +=  10.0
        setWidthHeightLabel()
    }
}

