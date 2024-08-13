//
//  GalleryCollectionViewLayout.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

protocol GalleryCollectionViewLayoutDelegate: AnyObject {
    func layoutStyleDidUpdate(_ style : GalleryCollectionViewLayout.Style)
}

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
    
    weak var delegate: GalleryCollectionViewLayoutDelegate?
    
    public var style: Style = .compact {
        didSet {
            delegate?.layoutStyleDidUpdate(style)
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
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: numberOfSections - 1)
            
            let attributes = GalleryCollectionViewLayoutAttributes(forCellWith: indexPath)

            let frame = CGRect(
                x: xOffset,
                y:  style == .compact ? yOffset : yOffset - 150,
                width: Constants.itemSize.width,
                height: Constants.itemSize.height
            )
            
            xOffset += Constants.itemSize.width + Constants.spacing
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
        let visibleAttributes = cache.filter { $0.frame.intersects(rect) }

        guard let collectionView = collectionView else { return visibleAttributes }
        
        let maxDistance = collectionView.bounds.width / 2
        
        // Define the maximum scale adjustment and the minimum scale
        let maxScaleAdjustment: CGFloat = style == .compact ? 0.25 : 0.50
        let minimumScale: CGFloat = 0.75
        
        for attributes in visibleAttributes {
            let distanceFromCenter = abs(attributes.center.x - collectionView.bounds.midX)
            
            // Normalize the distance so it ranges from 0 (center) to 1 (edge)
            let normalizedDistance = min(distanceFromCenter / maxDistance, 1.0)

            // Calculate the scale factor based on the normalized distance
            // Subtracting normalizedDistance from 1.0 inverts the scaling effect 1 (center) 0 (edge)
            let scaleFactor = minimumScale + (maxScaleAdjustment * (1.0 - normalizedDistance))
            attributes.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            
            // Adjust spacing based on the scaled size of the item
            if style == .full {
                if attributes.center.x < collectionView.bounds.midX {
                    // Item is to the left of the center
                    attributes.center.x -= Constants.spacing * scaleFactor
                } else if attributes.center.x > collectionView.bounds.midX {
                    // Item is to the right of the center
                    attributes.center.x += Constants.spacing * scaleFactor
                }
            }
        }
        
        return visibleAttributes
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
