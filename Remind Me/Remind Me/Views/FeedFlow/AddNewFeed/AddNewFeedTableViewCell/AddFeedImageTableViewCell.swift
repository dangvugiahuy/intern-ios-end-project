//
//  AddFeedImageTableViewCell.swift
//  Remind Me
//
//  Created by Huy Gia on 8/10/24.
//

import UIKit

class AddFeedImageTableViewCell: UITableViewCell {

    @IBOutlet weak var discardImageButton: UIButton!
    @IBOutlet weak var feedImageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            setupImageWithData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupImageWithData() {
        if let image = self.image {
            feedImageView.isHidden = false
            discardImageButton.isHidden = false
            feedImageView.image = image
            self.layoutIfNeeded()
        } else {
            feedImageView.isHidden = true
            discardImageButton.isHidden = true
        }
    }
}
