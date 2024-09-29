//
//  TaskListChooseColorCollectionViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 9/27/24.
//

import UIKit

class TaskListChooseColorCollectionViewCell: UICollectionViewCell {
    
    var hexColor: String? {
        didSet {
            setupUIWithData()
        }
    }

    @IBOutlet weak var colorItemImageView: UIImageView!
    @IBOutlet weak var colorItemChoosenImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorItemChoosenImageView.isHidden = isSelected ? false : true
    }
    
    override var isSelected: Bool {
        didSet {
            colorItemChoosenImageView.isHidden = isSelected ? false : true
        }
    }
    
    private func setupUIWithData() {
        if let hexColor = hexColor {
            colorItemImageView.tintColor = UIColor().colorFrom(hex: hexColor)
        }
    }
}
