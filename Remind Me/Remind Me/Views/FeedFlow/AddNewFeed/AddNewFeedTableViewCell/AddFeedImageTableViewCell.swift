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

    var images: [UIImage]? {
        didSet {
            setupCollectionImageWithData()
        }
    }
    
    weak var delegate: AddFeedImageTableViewCellDelegate?
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var discardImageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "PhotosPickerCollectionViewCell", bundle: .main)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "PhotosPickerCollectionCell")
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCollectionImageWithData() {
        if let images = self.images {
            imagesCollectionView.reloadData()
        }
    }
    
    @IBAction func discardImageButtonClicked(_ sender: Any) {
        delegate?.discardImage()
    }
}

extension AddFeedImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotosPickerCollectionCell", for: indexPath) as! PhotosPickerCollectionViewCell
        return cell
    }
}
