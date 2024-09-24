//
//  UIBarButtonItem.swift
//  Remind Me
//
//  Created by huy.dang on 9/24/24.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    func setupPlainBoldTitleButton() {
        let boldFont = [NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 17)]
        self.setTitleTextAttributes(boldFont as [NSAttributedString.Key : Any], for: .normal)
        self.setTitleTextAttributes(boldFont as [NSAttributedString.Key : Any], for: .disabled)
        self.setTitleTextAttributes(boldFont as [NSAttributedString.Key : Any], for: .highlighted)
        self.setTitleTextAttributes(boldFont as [NSAttributedString.Key : Any], for: .selected)
    }
    
    func setupPlainLightTitleButton() {
        let lightFont = [NSAttributedString.Key.font: UIFont(name: "Poppins-Light", size: 17)]
        self.setTitleTextAttributes(lightFont as [NSAttributedString.Key : Any], for: .normal)
        self.setTitleTextAttributes(lightFont as [NSAttributedString.Key : Any], for: .disabled)
        self.setTitleTextAttributes(lightFont as [NSAttributedString.Key : Any], for: .highlighted)
        self.setTitleTextAttributes(lightFont as [NSAttributedString.Key : Any], for: .selected)
    }
}
