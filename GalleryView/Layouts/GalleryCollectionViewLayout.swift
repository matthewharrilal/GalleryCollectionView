//
//  GalleryCollectionViewLayout.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

class GalleryCollectionViewLayout: UICollectionViewLayout {
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat {
        collectionView?.contentSize.height ?? 0
    }

    private var contentWidth: CGFloat = 0
    
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
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let frame = CGRect(x: xOffset + (CGFloat(item) * spacing), y: yOffset, width: itemSize.width, height: itemSize.height)
            
            xOffset += itemSize.width
            attributes.frame = frame
            
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
}
