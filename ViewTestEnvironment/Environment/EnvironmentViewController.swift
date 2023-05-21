//
//  EnvironmentViewController.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import Combine
import UIKit

final class EnvironmentViewController: UIViewController {
    
    // MARK: - Constant
    private static let sideButtonSize: CGFloat = 60.0
    
    // MARK: - Property
    private var isSelecting: Bool = false
    private var currentVCIdentifier: Config.SelectionItemIdentifier = .empty
    private var currentComponent: ComponentItem?
    
    private lazy var viewList: [SelectionItem] = Config.selectionList
    
    private var sideButtonConstraint: NSLayoutConstraint?
    private var selectionVCConstraint: NSLayoutConstraint?
    
    private lazy var sideButton: UIView = {
        let view: UIView = UIView()
        view.layer.addSublayer(setSideButtonLayer(size: Self.sideButtonSize))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sideButtonTapped)))
        return view
    }()
        
    private lazy var selectionVC: SelectionCellViewController = SelectionCellViewController()
    
    private lazy var selectionVCContainer: UIView = {
        let view: UIView = UIView()
        view.addSubview(selectionVC.view, constraintToEdges: true)
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.purple.cgColor
        return view
    }()
    
    private lazy var componentSearchContainer: UIView = UIView()
    
    private lazy var componentSearchLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .body), color: .black)
    
    private lazy var containerVC: UIView = UIView()
    private lazy var componentSelectionVC: ComponentSelectionViewController = ComponentSelectionViewController()
    
    // Need to be allocated beforehand
    private var constraintVC: ConstraintSectionViewController!
    private var sizeVC: SizeSectionViewController!
    private var collectionVerticalVC: CollectionVerticalSectionViewController!
    private var collectionHorizontalVC: CollectionHorizontalSectionViewController!
    private var collectionDynamicVC: CollectionDynamicSectionViewController!
    private var collectionCompositionalVC: CollectionCompositionalSectionViewController!
    private var tableVC: CollectionTableSectionViewController!
    private var stackVC: StackViewSectionViewController!
    
    private var bindings: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    // MARK: - Private Method
    private func setupBindings() {
        componentSelectionVC.selectionChoice
            .sink { [weak self] identifier in
                guard let self else { return }
                
                self.componentSearchLabel.text = "\(identifier) is selected"
                self.currentComponent = Config.availableComponentList.first(where: { $0.identifier == identifier })
                self.createContainerVC()
            }
            .store(in: &bindings)
        
    }
    
    private func setupView() {
        view.backgroundColor = .tertiarySystemBackground
        view.addSubviews(
            containerVC,
            sideButton,
            selectionVCContainer,
            componentSearchContainer
        )
        
        addChild(selectionVC)
        selectionVC.didMove(toParent: self)
        
        selectionVC.completionAction
            .sink { [weak self] index in
                self?.selectionFinished {
                    self?.currentComponent = Config.availableComponentList.first(where: { $0.identifier == self?.currentComponent?.identifier ?? "" })
                    self?.updateContainerContent(index: index)
                }
            }
            .store(in: &bindings)
        
        selectionVC.viewList = viewList
        
        sideButton.translatesAutoresizingMaskIntoConstraints = false
        sideButton.sizeAnchor(size: Self.sideButtonSize)
        sideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        sideButtonConstraint = sideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1.0)
        sideButtonConstraint?.isActive = true
        
        setupSearchContainer()
        
        containerVC.translatesAutoresizingMaskIntoConstraints = false
        containerVC.topAnchor.constraint(equalTo: componentSearchContainer.bottomAnchor, constant: 8.0).isActive = true
        containerVC.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerVC.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerVC.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        selectionVCConstraint = selectionVCContainer.leadingAnchor.constraint(equalTo: containerVC.trailingAnchor)
        selectionVCConstraint?.isActive = true
        
        selectionVCContainer.translatesAutoresizingMaskIntoConstraints = false
        selectionVCContainer.topAnchor.constraint(equalTo: componentSearchContainer.bottomAnchor, constant: -8.0).isActive = true
        selectionVCContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        selectionVCContainer.bottomAnchor.constraint(equalTo: containerVC.bottomAnchor).isActive = true
        selectionVCContainer.trailingAnchor.constraint(greaterThanOrEqualTo: containerVC.trailingAnchor).isActive = true
    }
    
    private func updateContainerContent(index: Int) {
        guard index < viewList.count else {
            return
        }
        
        let selectionItem: SelectionItem = viewList[index]
        currentVCIdentifier = selectionItem.identifier
        navigationItem.title = selectionItem.identifier.titleIdentifier()
        createContainerVC()
    }
    
    private func createContainerVC() {
        constraintVC = ConstraintSectionViewController()
        sizeVC = SizeSectionViewController()
        collectionVerticalVC = CollectionVerticalSectionViewController()
        collectionHorizontalVC = CollectionHorizontalSectionViewController()
        collectionDynamicVC =  CollectionDynamicSectionViewController()
        collectionCompositionalVC = CollectionCompositionalSectionViewController()
        tableVC = CollectionTableSectionViewController()
        stackVC = StackViewSectionViewController()

        switch currentVCIdentifier {
        case .constraint: setContainerVC(viewController: constraintVC)
        case .size: setContainerVC(viewController: sizeVC)
        case .collectionVertical: setContainerVC(viewController: collectionVerticalVC)
        case .collectionHorizontal: setContainerVC(viewController: collectionHorizontalVC)
        case .collectionDynamic: setContainerVC(viewController: collectionDynamicVC)
        case .collectionComposition: setContainerVC(viewController: collectionCompositionalVC)
        case .table: setContainerVC(viewController: tableVC)
        case .stack: setContainerVC(viewController: stackVC)
        default: setContainerVC(viewController: BaseSectionViewController())
        }
    }
    
    func setContainerVC<T: BaseSectionViewController>(viewController: T) {
        viewController.removeFromParent()
        containerVC.subviews.forEach{( $0.removeFromSuperview() )}
        viewController.assignedViews = currentComponent?.correspondingViews
        addChild(viewController)
        containerVC.addSubview(viewController.view, constraintToEdges: true)
        viewController.didMove(toParent: self)
    }
    
    private func setupSearchContainer() {
        let searchImageView: UIImageView = UIImageView()
        searchImageView.image = UIImage(systemName: "1.magnifyingglass")
        
        componentSearchLabel.text = "Choose your view."
        componentSearchContainer.backgroundColor = .white
        componentSearchContainer.layer.masksToBounds = false
        componentSearchContainer.layer.shadowColor = UIColor.gray.cgColor
        componentSearchContainer.layer.shadowOffset = .init(width: 0, height: 3)
        componentSearchContainer.layer.shadowRadius = 1.0
        componentSearchContainer.layer.shadowOpacity = 0.3
        
        componentSearchContainer.addSubviews(
            componentSearchLabel,
            searchImageView
        )
        
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.sizeAnchor(size: 24.0)
        searchImageView.leadingAnchor.constraint(equalTo: componentSearchContainer.leadingAnchor, constant: 8.0).isActive = true
        searchImageView.topAnchor.constraint(equalTo: componentSearchContainer.topAnchor,  constant: 8.0).isActive = true
        
        componentSearchLabel.translatesAutoresizingMaskIntoConstraints = false
        componentSearchLabel.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 8.0).isActive = true
        componentSearchLabel.topAnchor.constraint(equalTo: componentSearchContainer.topAnchor, constant: 8.0).isActive = true
        componentSearchLabel.bottomAnchor.constraint(equalTo: componentSearchContainer.bottomAnchor, constant: -8.0).isActive = true
        componentSearchLabel.trailingAnchor.constraint(equalTo: componentSearchContainer.trailingAnchor, constant: -8.0).isActive = true
        
        componentSearchContainer.translatesAutoresizingMaskIntoConstraints = false
        componentSearchContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        componentSearchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        componentSearchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        componentSearchContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchDidTapped)))
    }
    
    private func setSideButtonLayer(size: CGFloat) -> CALayer {
        let maskLayer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        path.move(to: CGPoint(x: size, y: .zero))
        path.addArc(
            withCenter: CGPoint(x: size, y: size / 2),
            radius: size / 2,
            startAngle: CGFloat.pi / 2.0,
            endAngle: CGFloat.pi * 1.5,
            clockwise: true
        )
        
        path.move(to: CGPoint(x: size / 2 + 8, y: size / 2 - 6))
        path.addLine(to: CGPoint(x: size - 2, y: size / 2 - 6))
        
        path.move(to: CGPoint(x: size / 2 + 8, y: size / 2))
        path.addLine(to: CGPoint(x: size - 2, y: size / 2))
        
        path.move(to: CGPoint(x: size / 2 + 8, y: size / 2 + 6))
        path.addLine(to: CGPoint(x: size - 2, y: size / 2 + 6))
        
        maskLayer.path = path.cgPath
        maskLayer.fillColor  = UIColor.purple.cgColor
        maskLayer.strokeColor  = UIColor.systemPink.cgColor
        maskLayer.lineWidth = 2.0
        return maskLayer
    }
    
    @objc
    private func sideButtonTapped() {
        sideButton.isUserInteractionEnabled = false
        UIView.animate(
            withDuration: 0.5,
            delay: .zero,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 4,
            options: .curveEaseInOut) {
                self.handleAnimationBegin()
            } completion: { _ in
                self.handleAnimationCompletion()
            }
    }
    
    private func selectionFinished(completion: @escaping () -> Void) {
        sideButton.isUserInteractionEnabled = false
        UIView.animate(
            withDuration: 0.5,
            delay: .zero,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 4,
            options: .curveEaseInOut) {
                self.handleAnimationBegin()
            } completion: { _ in
                self.handleAnimationCompletion()
                completion()
            }
    }
    
    private func handleAnimationBegin() {
        let selectionWidth: CGFloat = view.frame.width - 60

        if self.isSelecting {
            self.sideButton.frame.origin.x += selectionWidth
            self.selectionVCContainer.frame.origin.x += selectionWidth
        }
        else {
            self.sideButton.frame.origin.x -= selectionWidth
            self.selectionVCContainer.frame.origin.x -= selectionWidth
        }
    }
    
    private func handleAnimationCompletion() {
        let selectionWidth: CGFloat = view.frame.width - 60

        self.sideButton.isUserInteractionEnabled = true
        self.isSelecting.toggle()
        if self.isSelecting {
            self.selectionVCConstraint?.constant = -selectionWidth
            self.sideButtonConstraint?.constant = 1 - selectionWidth
        }
        else {
            self.selectionVCConstraint?.constant = 0
            self.sideButtonConstraint?.constant = 1
        }
    }
    
    @objc
    private func searchDidTapped() {
        componentSelectionVC.viewList = Config.availableComponentList
        navigationController?.present(componentSelectionVC, animated: true)
    }
}
