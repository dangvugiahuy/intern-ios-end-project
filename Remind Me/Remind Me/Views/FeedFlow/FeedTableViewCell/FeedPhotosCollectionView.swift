//
//  FeedPhotosCollectionView.swift
//  Remind Me
//
//  Created by huy.dang on 10/11/24.
//

import UIKit

class FeedPhotosCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
