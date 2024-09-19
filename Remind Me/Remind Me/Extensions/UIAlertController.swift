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
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        vc.present(alert, animated: true)
    }
}
