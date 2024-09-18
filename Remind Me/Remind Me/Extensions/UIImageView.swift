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
    
    func loadImageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image = UIImage(named: "AvatarDefault")
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
