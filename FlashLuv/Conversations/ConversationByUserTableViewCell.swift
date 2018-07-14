//
//  ConversationByUserTableViewCell.swift
//  FlashLuv
//
//  Created by Isma Dia on 14/07/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

class ConversationByUserTableViewCell: UITableViewCell {
    @IBOutlet weak var conversationTitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
