//
//  AddFeedContentTableViewCell.swift
//  Remind Me
//
//  Created by Huy Gia on 8/10/24.
//

import UIKit

protocol AddFeedContentTableViewCellDelegate: AnyObject {
    func updateCellHeight(_ cell: AddFeedContentTableViewCell, _ textView: UITextView)
}

class AddFeedContentTableViewCell: UITableViewCell {
    
    weak var delegate: AddFeedContentTableViewCellDelegate?
    
    @IBOutlet weak var contentPlaceholderLabel: UILabel!
    @IBOutlet weak var feedContentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        feedContentTextView.delegate = self
        feedContentTextView.becomeFirstResponder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension AddFeedContentTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        contentPlaceholderLabel.isHidden = feedContentTextView.text != "" ? true : false
        delegate?.updateCellHeight(self, self.feedContentTextView)
    }
}
