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
    
    enum Style {
        case compact
        case full
        
        mutating func toggle() {
            switch self {
            case .compact:
                self = .compact
            case .full:
                self = .full
            }
        }
    }
    
    public var style: Style = .compact {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.invalidateLayout()
            }
        }
    }
    private var cache: [GalleryCollectionViewLayoutAttributes] = []
    private var colorCache: [IndexPath: UIColor] = [:]
    
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

            let frame = CGRect(x: xOffset + (CGFloat(item) * spacing), y:  style == .compact ? yOffset : yOffset - 300, width: Constants.itemSize.width, height: Constants.itemSize.height)
            
            xOffset += Constants.itemSize.width
            attributes.frame = frame
            
            attributes.containerColor = colorCache[indexPath] ?? {
                let color = UIView.colors.randomElement()
                colorCache[indexPath] = color
                return color
            }()

            cache.append(attributes)
            contentWidth = frame.maxX
        }
    }
    
    public func toggleStyle() {
        style.toggle()
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
        guard let collectionView = collectionView else { return cache }
        
        let centerX = collectionView.bounds.midX + collectionView.contentOffset.x
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        
        let attributesArray = cache.filter { $0.frame.intersects(visibleRect) }
        
        for attributes in attributesArray {
            let distanceFromCenter = abs(attributes.center.x - collectionView.bounds.midX)
            let maxDistance = collectionView.bounds.width / 2
            let normalizedDistance = min(distanceFromCenter / maxDistance, 1.0)
            
            // Scale between 0.75 and 1.0
            let scaleFactor = 0.75 + (0.25 * (1.0 - normalizedDistance))
            attributes.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
        
        return attributesArray        
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let pageWidth = Constants.itemSize.width + Constants.spacing
        let proposedPage = round(proposedContentOffset.x / pageWidth)
        return CGPoint(x: proposedPage * pageWidth, y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}
