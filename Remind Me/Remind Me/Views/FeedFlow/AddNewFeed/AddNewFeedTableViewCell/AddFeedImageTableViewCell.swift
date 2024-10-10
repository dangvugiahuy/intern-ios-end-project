//
//  AddFeedImageTableViewCell.swift
//  Remind Me
//
//  Created by Huy Gia on 8/10/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout

protocol AddFeedImageTableViewCellDelegate: AnyObject {
    func discardImage()
}

class AddFeedImageTableViewCell: UITableViewCell {
    
    var localImages: [UIImage] = [UIImage]()

    var images: [UIImage]? {
        didSet {
            setupUIWithData()
        }
    }
    
    weak var delegate: AddFeedImageTableViewCellDelegate?
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var discardImageButton: UIButton!
    @IBOutlet weak var imagesCollectionViewHeightConstrant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "PhotosPickerCollectionViewCell", bundle: .main)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "PhotosPickerCollectionCell")
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        imagesCollectionView.alwaysBounceVertical = true
        imagesCollectionView.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUIWithData() {
        if let images = images {
            localImages = images
            imagesCollectionView.reloadData()
            imagesCollectionView.performBatchUpdates {
                let height: CGFloat = imagesCollectionView.collectionViewLayout.collectionViewContentSize.height
                imagesCollectionViewHeightConstrant.constant = height
            }
        }
    }
    
    @IBAction func discardImageButtonClicked(_ sender: Any) {
        delegate?.discardImage()
    }
}

extension AddFeedImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize = localImages[indexPath.item].size
        return imageSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotosPickerCollectionCell", for: indexPath) as! PhotosPickerCollectionViewCell
        cell.image = localImages[indexPath.item]
        return cell
    }
}
