//
//  GalleryCollectionViewLayoutAttributes.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

class GalleryCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // Purpose: This property is added to hold additional information (in this case, a color) that is not provided by the default UICollectionViewLayoutAttributes.
    var containerColor: UIColor?
    
  //Purpose: This method ensures that when the layout attributes are copied (e.g., for use in animations or snapshots), the custom property is also copied. Without this, the containerColor might be lost during the copy process.
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! GalleryCollectionViewLayoutAttributes
        copy.containerColor = self.containerColor
        return copy
    }
    
    // This method allows comparisons between layout attributes instances to determine equality. It's important for ensuring that custom properties are taken into account when comparing layout attributes.
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? GalleryCollectionViewLayoutAttributes else {
            return false
        }
        
        return super.isEqual(other) && other.containerColor == self.containerColor
    }
}
