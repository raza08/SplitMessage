//
//  MessageViewCell.swift
//  SplitMessage
//
//  Created by Raza Khan on 16/03/19.
//  Copyright © 2019 Raza Khan. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageView: UIView!

    var messageString : String? {
        didSet{
            self.messageLabel.text = messageString
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageView.layer.cornerRadius = 20
        self.messageView.layer.masksToBounds = true
        backgroundColor = UIColor.clear


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
