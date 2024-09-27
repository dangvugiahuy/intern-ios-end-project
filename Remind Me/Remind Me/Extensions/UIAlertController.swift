//
//  UIAlertController.swift
//  Remind Me
//
//  Created by huy.dang on 9/17/24.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func showSimpleAlertWithOKButton(on vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Remind Me", message: message, preferredStyle: .alert)
        alert.setTitleAtt(font: UIFont(name: "Poppins-SemiBold", size: 18), color: UIColor(named: "Primary900"))
        alert.setMessageAtt(font: UIFont(name: "Poppins-Light", size: 14), color: UIColor(named: "Greyscale800"))
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.view.tintColor = UIColor(named: "Greyscale800")
        vc.present(alert, animated: true)
    }
    
    static func createSimpleAlert(with title: String, and message: String, style: UIAlertController.Style) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.setTitleAtt(font: UIFont(name: "Poppins-SemiBold", size: 18), color: UIColor(named: "Primary900"))
        alert.setMessageAtt(font: UIFont(name: "Poppins-Light", size: 14), color: UIColor(named: "Greyscale800"))
        return alert
    }
    
    func setTitleAtt(font: UIFont?, color: UIColor?) {
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
    
    func setMessageAtt(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attString = NSMutableAttributedString(string: message)
        let range = NSRange(location: 0, length: (message as NSString).length)
        if let messageFont = font {
            attString.addAttribute(NSAttributedString.Key.font, value: messageFont, range: range)
        }
        if let messageColor = color {
            attString.addAttribute(NSAttributedString.Key.foregroundColor, value: messageColor, range: range)
        }
        self.setValue(attString, forKey: "attributedMessage")
    }
    
}
