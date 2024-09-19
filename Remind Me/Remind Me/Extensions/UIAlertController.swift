//
//  UIAlertController.swift
//  Remind Me
//
//  Created by huy.dang on 9/17/24.
//

import Foundation
import UIKit

extension UIAlertController {
    static func showErrorAlert(on vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Remind Me", message: message, preferredStyle: .alert)
        alert.setTitleAtt(font: UIFont(name: "Poppins-SemiBold", size: 16), color: UIColor(named: "Primary900"))
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        vc.present(alert, animated: true)
    }
    
    private func setTitleAtt(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attString = NSMutableAttributedString(string: title)
        let range = NSRange(location: 0, length: (title as NSString).length)
        if let titleFont = font {
            attString.addAttribute(NSAttributedString.Key.font, value: titleFont, range: range)
        }
        if let titleColor = color {
            attString.addAttribute(NSAttributedString.Key.foregroundColor, value: titleColor, range: range)
        }
        self.setValue(attString, forKey: "attributedTitle")
    }
    
    private func setMessageAtt(font: UIFont?, color: UIColor?) {
        
    }
}
