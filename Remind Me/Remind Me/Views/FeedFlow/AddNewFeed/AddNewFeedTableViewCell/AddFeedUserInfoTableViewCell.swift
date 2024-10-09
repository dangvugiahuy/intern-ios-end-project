//
//  AddFeedUserInfoTableViewCell.swift
//  Remind Me
//
//  Created by Huy Gia on 8/10/24.
//

import UIKit

class AddFeedUserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userAvtImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userAvtImageView.setupAvtImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
