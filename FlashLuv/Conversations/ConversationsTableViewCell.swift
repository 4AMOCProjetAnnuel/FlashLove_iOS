//
//  ConversationsTableViewCell.swift
//  FlashLuv
//
//  Created by Isma Dia on 13/07/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase

class ConversationsTableViewCell: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var userImageView: UIImageView!
    var conversation : Conversation? {
        didSet {
            setupNameAndAvatar()
            if let seconds = conversation?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    private func setupNameAndAvatar(){
        if let id = conversation?.conversationParnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshot) in
                if let userFieldDictionnary = snapshot.value as? [String: Any]{
                    self.userName.text = userFieldDictionnary["displayName"] as? String
                    if let link = userFieldDictionnary["photoUrl"] as? String  {
                        self.userImageView.downloadedFrom(link: link)
                    }
                    
                    
                }
            }, withCancel: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 50
        userImageView.contentMode = .scaleAspectFit
        userImageView.clipsToBounds = true
        
        userName.font = UIFont(name: "Lato-Regular", size: 18)
        userName.textColor = UIColor().getPrimaryPinkDark()
        addSubview(timeLabel)
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //timeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
