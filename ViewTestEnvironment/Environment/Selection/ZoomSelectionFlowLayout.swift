//
//  ZoomSelectionFlowLayout.swift
//  ViewTestEnvironment
//
//  Created by William William on 20/05/23.
//

import UIKit

// simplified revolving cell from: https://github.com/zepojo/UPCarouselFlowLayout
final class ZoomSelectionFlowLayout: UICollectionViewFlowLayout {
    // MARK: - Constant
    private static let sideItemScale: CGFloat = 0.6
    private static let sideItemAlpha: CGFloat = 0.6
    
    // MARK: - Struct
    private struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
        func isEqual(_ otherState: LayoutState) -> Bool {
            size.equalTo(otherState.size) && direction == otherState.direction
        }
    }
    
    // MARK: - Cache
    private var state = LayoutState(size: CGSize.zero, direction: .horizontal)
    
    // MARK: - Return offset
    var newProposedOffsetAction: ((IndexPath) -> Void)?
    
    // MARK: - Override
    override func prepare() {
        super.prepare()
        let currentState: LayoutState = LayoutState(size: collectionView?.bounds.size ?? .zero, direction: scrollDirection)
        
        if !state.isEqual(currentState) {
            setupCollectionView()
            updateLayout()
            state = currentState
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView: UICollectionView = collectionView , !collectionView.isPagingEnabled,
              let layoutAttributes: [UICollectionViewLayoutAttributes] = layoutAttributesForElements(in: collectionView.bounds)
        else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let isHorizontal: Bool = self.scrollDirection == .horizontal
        
        let midSide: CGFloat = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin: CGFloat = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        if isHorizontal {
            let closestAttributes: UICollectionViewLayoutAttributes = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closestAttributes.center.x - midSide), y: proposedContentOffset.y)
            newProposedOffsetAction?(IndexPath(row: getIndex(from: closestAttributes.frame.maxX, cellSize: closestAttributes.size.width), section: .zero))
        }
        else {
            let closestAttributes: UICollectionViewLayoutAttributes = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closestAttributes.center.y - midSide))
            newProposedOffsetAction?(IndexPath(row: getIndex(from: closestAttributes.frame.maxY, cellSize: closestAttributes.size.height), section: .zero))
        }
        
        return targetContentOffset
    }
    
    // MARK: - Private Method
    private func getIndex(from distance: CGFloat, cellSize: CGFloat) -> Int {
        var index: Int = .zero
        var mutableDistance: CGFloat = distance
        while mutableDistance > .zero {
            mutableDistance -= cellSize
            mutableDistance -= minimumLineSpacing
            index += 1
        }
        return index - 3
    }
    
    private func setupCollectionView() {
        guard let collectionView: UICollectionView = collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }
    
    private func updateLayout() {
        guard let collectionView: UICollectionView = collectionView else { return }
        
        let collectionSize: CGSize = collectionView.bounds.size
        let isHorizontal: Bool = (scrollDirection == .horizontal)
        
        let yInset: CGFloat = (collectionSize.height - itemSize.height) / 2
        let xInset: CGFloat = (collectionSize.width - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let side: CGFloat = isHorizontal ? itemSize.width : itemSize.height
        let scaledItemOffset: CGFloat = (side - side * Self.sideItemScale) / 2
        minimumLineSpacing = 40.0 - scaledItemOffset
    }
    
    private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView: UICollectionView = collectionView else { return attributes }
        let isHorizontal: Bool = scrollDirection == .horizontal
        
        let collectionCenter: CGFloat = isHorizontal ? collectionView.bounds.size.width / 2 : collectionView.bounds.size.height / 2
        let offset: CGFloat = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter: CGFloat = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance: CGFloat = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance: CGFloat = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio: CGFloat = (maxDistance - distance) / maxDistance
        
        let alpha: CGFloat = ratio * (1 - Self.sideItemAlpha) + Self.sideItemAlpha
        let scale: CGFloat = ratio * (1 - Self.sideItemScale) + Self.sideItemScale
        let shift: CGFloat = 1 - ratio
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)
        
        if isHorizontal {
            attributes.center.y = attributes.center.y + shift
        } else {
            attributes.center.x = attributes.center.x + shift
        }
        
        return attributes
    }
}
