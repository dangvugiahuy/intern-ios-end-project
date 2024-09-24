//
//  UIButtonExtension.swift
//  Remind Me
//
//  Created by huy.dang on 9/13/24.
//

import Foundation
import UIKit

extension UIButton {
    func setupFilledButton() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    func hideShowPasswordButtonConfig() {
        self.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        self.setImage(UIImage(systemName: "eye.fill"), for: .selected)
    }
    
    func setupCircleButton() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
    }
}
