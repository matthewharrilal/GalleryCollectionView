//
//  GalleryCollectionViewLayout.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

class GalleryCollectionViewLayout: UICollectionViewLayout {
    
    private var cache: [GalleryCollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat {
        collectionView?.contentSize.height ?? 0
    }

    private var contentWidth: CGFloat = 0
    
    // Computed property to expose contentWidth as read-only
    public var visibleContentWidth: CGFloat {
        return contentWidth
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        contentWidth = 0
        cache.removeAll()
        
        let itemSize = CGSize(width: 250, height: 250)
        
        var xOffset = (UIScreen.main.bounds.width / 2) - (itemSize.width / 2)
        let yOffset = (UIScreen.main.bounds.height / 2) - (itemSize.height / 2)
        
        let numberOfSections = collectionView.numberOfSections
        let numberOfItems = collectionView.numberOfItems(inSection: numberOfSections - 1)
        let spacing: CGFloat = 25
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: numberOfSections - 1)
            
            let attributes = GalleryCollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let frame = CGRect(x: xOffset + (CGFloat(item) * spacing), y: yOffset, width: itemSize.width, height: itemSize.height)
            
            xOffset += itemSize.width
            attributes.frame = frame
            attributes.containerColor = UIView.colors.randomElement()

            cache.append(attributes)
            contentWidth = frame.maxX
        }
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        
        return cache.first { $0.indexPath == indexPath }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        
        // Define current rectangle in view at the point scrolling stops
        // Proposed content offset is the guestimation based on the velocity where the collection view will stop scrolling
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        // Get the layout attributes for all the cells in the visible rect
        guard let layoutAttributes = layoutAttributesForElements(in: targetRect) else {
            return proposedContentOffset
        }
        
        // Gives us the center of the cell we end on relative to the collection view size ... having trouble visualizing this
        let horizontalCenter = proposedContentOffset.x + (collectionView.bounds.width / 2)
        
        var closestAttribute: UICollectionViewLayoutAttributes?
        
        for attributes in layoutAttributes {
            if closestAttribute == nil || abs(attributes.center.x - horizontalCenter) < abs(closestAttribute!.center.x - horizontalCenter) {
                closestAttribute = attributes
            }
        }
        
        guard let closestAttribute = closestAttribute else { return proposedContentOffset }
        
        let targetOffsetX = closestAttribute.center.x - (collectionView.bounds.width / 2)
        
        return CGPoint(x: targetOffsetX, y: proposedContentOffset.y)
    }
}
