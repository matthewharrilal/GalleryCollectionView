//
//  GalleryViewController+UICollectionViewDelegate.swift
//  GalleryView
//
//  Created by Space Wizard on 8/12/24.
//

import Foundation
import UIKit

extension GalleryViewController: UICollectionViewDelegate {
    
    // Comment above describes how in the course of "one" continuous scroll multiple animation blocks can happen due to "one continous" scroll not being real but rather incremental updates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout
        else { return }
        
        // Get the visible rect of the collection view
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        
        // Get the attributes for all cells in the visible rect
        guard let visibleAttributes = layout.layoutAttributesForElements(in: visibleRect) else { return }
        
        // Find the attribute that is closest to the center of the collection view
        var closestAttribute: UICollectionViewLayoutAttributes?
        var minimumDistance: CGFloat = 30
        
        // As the user scrolls:
        // - The distance between the center of the cell (attribute.center.x) and
        //   the center of the viewable width (centerX) gets smaller.
        // - This smaller distance updates the `distance` variable, qualifying
        //   this cell (attribute) to be the new closest-to-center cell.
        // - Consequently, the color of the collection view background changes
        //   to match the color of this closest-to-center cell.
        for attribute in visibleAttributes {
            let distance = abs(attribute.center.x - collectionView.bounds.midX)
            
            if distance < minimumDistance {
                minimumDistance = distance
                closestAttribute = attribute
            }
        }
        
        if let closestAttribute = closestAttribute as? GalleryCollectionViewLayoutAttributes {
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveLinear]) { [weak self] in
                self?.titleLabel.alpha = 0
                collectionView.backgroundColor = closestAttribute.containerColor?.withAlphaComponent(0.2)
            }
        }
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard
            let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout,
            let visibleAttributes = layout.layoutAttributesForElements(
                in: CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            )
        else { return }
        
        var minimumDistance = CGFloat.greatestFiniteMagnitude
        var closestAttribute: UICollectionViewLayoutAttributes?

        for attribute in visibleAttributes {
            let distance = abs(attribute.center.x - collectionView.bounds.midX)

            if distance < minimumDistance {
                minimumDistance = distance
                closestAttribute = attribute
            }
        }
        
        if let _ = closestAttribute as? GalleryCollectionViewLayoutAttributes {
            titleLabel.text = UIView.singleWordArray.randomElement()

            UIView.animate(withDuration: 0.10, delay: 0, options: [.curveEaseOut]) { [weak self] in                self?.titleLabel.alpha = 1
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Enforce compact scrolling to avoid UI issues with spacing between items in full layout
        guard
            let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout
        else { return }
        
        layout.style = .compact
    }
}
