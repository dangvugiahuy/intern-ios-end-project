//
//  UISegmentedControl.swift
//  Remind Me
//
//  Created by huy.dang on 9/24/24.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func setupSegment() {
        let textAttNormal = [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 15), NSAttributedString.Key.foregroundColor: UIColor.greyscale800]
        let textAttSelect = [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 15), NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setTitleTextAttributes(textAttNormal as [NSAttributedString.Key : Any], for: .normal)
        self.setTitleTextAttributes(textAttSelect as [NSAttributedString.Key : Any], for: .selected)
    }
}
