//
//  UITableView.swift
//  Remind Me
//
//  Created by huy.dang on 9/30/24.
//

import Foundation
import UIKit

extension UITableView {
    func createViewWhenEmptyData(title: String) {
        let backgroundView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.frame.size.width, height: self.frame.size.height))
        backgroundView.backgroundColor = .clear
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Medium", size: 15)
        label.textColor = UIColor.greyscale600
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 270).isActive = true
        self.backgroundView = backgroundView
    }
}
