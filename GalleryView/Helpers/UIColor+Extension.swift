//
//  UIColor+Extension.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        // Remove hash (#) if present
        let cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let hexString: String
        if cleanedHex.hasPrefix("#") {
            hexString = String(cleanedHex.dropFirst())
        } else {
            hexString = cleanedHex
        }
        
        var rgb: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        let alpha = CGFloat(1.0)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
