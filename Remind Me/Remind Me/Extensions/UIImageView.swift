//
//  UIImageView.swift
//  Remind Me
//
//  Created by huy.dang on 9/16/24.
//

import Foundation
import UIKit

extension UIImageView {
    func setupAvtImage() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
    }
}
