//
//  +Constraint.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

extension UIView {
    func constraintToEdges(
        of view: UIView,
        inset: UIEdgeInsets = .zero,
        isSafeArea: Bool = false
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        if !isSafeArea {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset.left).isActive = true
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: inset.top).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset.right).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset.bottom).isActive = true
        }
        else {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: inset.left).isActive = true
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: inset.top).isActive = true
            view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -inset.right).isActive = true
            view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -inset.bottom).isActive = true
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach({ addSubview($0) })
    }
    
    func addSubview(_ view: UIView, constraintToEdges: Bool = false) {
        addSubview(view)
        if constraintToEdges {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.constraintToEdges(of: self)
        }
    }
    
    func sizeAnchor(size: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
    }
}
