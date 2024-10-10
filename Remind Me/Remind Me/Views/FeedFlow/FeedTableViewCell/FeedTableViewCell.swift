//
//  FeedTableViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 10/8/24.
//

import UIKit
import SkeletonView

class FeedTableViewCell: UITableViewCell {
    
    private let vm: FeedCellViewModel = FeedCellViewModel()
    
    var feed: Feed? {
        didSet {
            setUIWithData()
        }
    }
    
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedImageHeightConstrant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vm.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUIWithData() {
        if let feed = self.feed {
            createDateLabel.text = Date.dateToString(date: feed.createDate, format: "EEE, MMM d")
            contentLabel.text = feed.content
            feedImageView.isHidden = feed.imageURL == nil ? true : false
            feedImageHeightConstrant.constant = feedImageView.isHidden ? 0 : 0.75 * feedImageView.frame.width
            if feedImageView.image == nil {
                feedImageView.showAnimatedGradientSkeleton()
                if let imageURL = feed.imageURL {
                    vm.getImage(imageURL: imageURL)
                }
            }
        }
    }
}

extension FeedTableViewCell: FeedCellViewModelDelegate {
    func setImage(image: UIImage) {
        feedImageView.hideSkeleton()
        self.feedImageView.image = image
    }
}
