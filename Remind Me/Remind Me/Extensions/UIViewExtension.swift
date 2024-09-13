//
//  UIViewExtension.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import Foundation
import UIKit

extension UIView {
    func textFieldViewConfig() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 4
    }
}
