//
//  PhotosPickerCollectionViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 10/10/24.
//

import UIKit

class PhotosPickerCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            photosImageView.image = image
        }
    }
    
    @IBOutlet weak var photosImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
    }
}
