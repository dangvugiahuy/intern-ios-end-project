//
//  FeedPhotosCollectionViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 10/11/24.
//

import UIKit

class FeedPhotosCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            feedPhotoImage.image = image
        }
    }

    @IBOutlet weak var feedPhotoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
    }
}
