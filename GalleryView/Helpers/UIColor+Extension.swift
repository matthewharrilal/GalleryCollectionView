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
    
    static func blendColor(from startColor: UIColor, to endColor: UIColor, percentage: CGFloat) -> UIColor {
        // Ensure percentage is between 0 and 1
        let clampedPercentage = max(0, min(percentage, 1))
        
        // Get the RGBA components of the colors
        var startRed: CGFloat = 0
        var startGreen: CGFloat = 0
        var startBlue: CGFloat = 0
        var startAlpha: CGFloat = 0
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        
        var endRed: CGFloat = 0
        var endGreen: CGFloat = 0
        var endBlue: CGFloat = 0
        var endAlpha: CGFloat = 0
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        // Interpolate between the colors
        let blendedRed = startRed + (endRed - startRed) * clampedPercentage
        let blendedGreen = startGreen + (endGreen - startGreen) * clampedPercentage
        let blendedBlue = startBlue + (endBlue - startBlue) * clampedPercentage
        let blendedAlpha = startAlpha + (endAlpha - startAlpha) * clampedPercentage
        
        // Return the blended color
        return UIColor(red: blendedRed, green: blendedGreen, blue: blendedBlue, alpha: blendedAlpha)
    }
}
