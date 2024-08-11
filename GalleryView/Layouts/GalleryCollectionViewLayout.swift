//
//  GalleryCollectionViewLayout.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

class GalleryCollectionViewLayout: UICollectionViewLayout {
    
    enum Constants {
        static let itemSize = CGSize(width: 250, height: 250)
        static let spacing: CGFloat = 25
    }
    
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
        
        
        var xOffset = (UIScreen.main.bounds.width / 2) - (Constants.itemSize.width / 2)
        let yOffset = (UIScreen.main.bounds.height / 2) - (Constants.itemSize.height / 2)
        
        let numberOfSections = collectionView.numberOfSections
        let numberOfItems = collectionView.numberOfItems(inSection: numberOfSections - 1)
        let spacing: CGFloat = Constants.spacing
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: numberOfSections - 1)
            
            let attributes = GalleryCollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let frame = CGRect(x: xOffset + (CGFloat(item) * spacing), y: yOffset, width: Constants.itemSize.width, height: Constants.itemSize.height)
            
            xOffset += Constants.itemSize.width
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
        let pageWidth = Constants.itemSize.width + Constants.spacing
        let proposedPage = round(proposedContentOffset.x / pageWidth)
        return CGPoint(x: proposedPage * pageWidth, y: proposedContentOffset.y)
    }
}
