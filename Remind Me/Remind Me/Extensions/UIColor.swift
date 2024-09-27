//
//  UIColor.swift
//  Remind Me
//
//  Created by huy.dang on 9/27/24.
//

import Foundation
import UIKit

extension UIColor {
    func colorFrom(hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hex.startIndex)
        }
        
        if hexString.count != 6 {
            return .blue
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: 1.0)
    }
}
