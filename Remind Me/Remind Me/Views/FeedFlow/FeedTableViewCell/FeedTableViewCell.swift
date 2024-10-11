//
//  FeedTableViewCell.swift
//  Remind Me
//
//  Created by huy.dang on 10/8/24.
//

import UIKit
import SkeletonView
import CHTCollectionViewWaterfallLayout

protocol FeedTableViewCellDelegate: AnyObject {
    func update(at cell: UITableViewCell)
}

class FeedTableViewCell: UITableViewCell {
    
    private let vm: FeedCellViewModel = FeedCellViewModel()
    private var images: [UIImage] = [UIImage]()
    weak var delegate: FeedTableViewCellDelegate?
    
    var feed: Feed? {
        didSet {
            setUIWithData()
        }
    }
    
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showAnimatedGradientSkeleton()
        let nib = UINib(nibName: "FeedPhotosCollectionViewCell", bundle: .main)
        photosCollectionView.register(nib, forCellWithReuseIdentifier: "FeedPhotosCollectionViewCell")
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        photosCollectionView.alwaysBounceVertical = true
        photosCollectionView.collectionViewLayout = layout
        vm.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        images = []
        photosCollectionView.reloadData()
    }
    
    private func setUIWithData() {
        if let feed = self.feed {
            createDateLabel.text = Date.dateToString(date: feed.createDate, format: "EEE, MMM d")
            contentLabel.text = feed.content
            if let imagesURL = feed.imagesURL {
                if imagesURL.isEmpty {
                    photosCollectionView.isHidden = true
                } else {
                    photosCollectionView.isHidden = false
                    vm.getImages(from: feed)
                }
            }
        }
    }
}

extension FeedTableViewCell: FeedCellViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "FeedPhotosCollectionViewCell"
    }
    
    func returnImages(images: [UIImage]) {
        self.images = images
        photosCollectionView.reloadData()
        photosCollectionView.performBatchUpdates {
            photosCollectionView.layoutIfNeeded()
//            delegate?.update(at: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize = images[indexPath.item].size
        return imageSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "FeedPhotosCollectionViewCell", for: indexPath) as! FeedPhotosCollectionViewCell
        cell.image = images[indexPath.item]
        return cell
    }
}
