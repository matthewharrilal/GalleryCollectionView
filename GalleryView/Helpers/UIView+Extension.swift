//
//  UIView+Extension.swift
//  GalleryView
//
//  Created by Space Wizard on 8/9/24.
//

import Foundation
import UIKit

extension UIView {
    static var singleWordArray: [String] = [
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Elderberry",
        "Fig",
        "Grape",
        "Honeydew",
        "Kiwi",
        "Lemon",
        "Mango",
        "Nectarine",
        "Orange",
        "Papaya",
        "Quince",
        "Raspberry",
        "Strawberry",
        "Tangerine",
        "Uva",        // Note: "Uva" is the Spanish word for "Grape"
        "Vanilla",
        "Watermelon",
        "Xylocarp",   // A less common word for "Coconut"
        "Yam",
        "Zucchini"
    ]
    
    static var colors: [UIColor] = [
        UIColor(hex: "FF5733"), // Vivid Orange-Red
        UIColor(hex: "33FF57"), // Bright Lime Green
        UIColor(hex: "3357FF"), // Vivid Blue
        UIColor(hex: "FF33A1"), // Hot Pink
        UIColor(hex: "33FFF0"), // Bright Cyan
        UIColor(hex: "FFBF00"), // Bright Yellow-Orange
        UIColor(hex: "B233FF"), // Bright Purple
        UIColor(hex: "FF6F61"), // Coral
        UIColor(hex: "1E88E5"), // Strong Blue
        UIColor(hex: "D32F2F"), // Deep Red
        UIColor(hex: "7B1FA2"), // Deep Purple
        UIColor(hex: "004D40"), // Dark Teal
        UIColor(hex: "FF7043"), // Vibrant Orange
        UIColor(hex: "8E24AA"), // Rich Purple
        UIColor(hex: "388E3C"), // Forest Green
        UIColor(hex: "FDD835"), // Bright Yellow
        UIColor(hex: "0288D1"), // Sky Blue
        UIColor(hex: "F48FB1"), // Light Pink
        UIColor(hex: "80CBC4"), // Light Teal
        UIColor(hex: "A5D6A7"), // Light Green
        UIColor(hex: "FFAB91"), // Light Coral
        UIColor(hex: "DCE775"), // Light Yellow
        UIColor(hex: "CE93D8"), // Light Purple
        UIColor(hex: "B3E5FC"), // Light Blue
        UIColor(hex: "E6EE9C"), // Light Lime Green
        UIColor(hex: "B2DFDB"), // Light Cyan
        UIColor(hex: "FFCC80")  // Light Orange
    ]
    
    func addSubviews(views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
