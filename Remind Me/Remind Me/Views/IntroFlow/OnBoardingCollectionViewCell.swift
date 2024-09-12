//
//  OnBoardingCollectionViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 9/12/24.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    var slide: OnboardingSlide? {
        didSet {
            setupData()
        }
    }

    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideSubtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setupData() {
        if let slide = slide {
            slideImageView.image = slide.image
            slideTitleLabel.text = slide.title
            slideSubtitleLabel.text = slide.subtitle
        }
    }
}
