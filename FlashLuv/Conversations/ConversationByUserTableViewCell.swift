//
//  ConversationByUserTableViewCell.swift
//  FlashLuv
//
//  Created by Isma Dia on 14/07/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase

class ConversationByUserTableViewCell: UITableViewCell {

    @IBOutlet weak var dataCapteurStackView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    let heartBeatViewContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let heartBeatImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bar_chart")
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor().getPrimaryPinkDark()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let heartBeatLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/200"
        label.textAlignment = .center
        label.textColor = UIColor().getPrimaryPinkDark()
        label.font =  UIFont(name: "Lato-Regular", size: 14)
        return label
    }()
    
    let humidityViewContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let humidityImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "water")
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor().getPrimaryPinkDark()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let humidityLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/200"
        label.textAlignment = .center
        label.textColor = UIColor().getPrimaryPinkDark()
        label.font =  UIFont(name: "Lato-Regular", size: 14)
        return label
    }()
    
    let temperatureViewContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let temperatureImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "thermometer")
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor().getPrimaryPinkDark()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let temperatureLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/200"
        label.textAlignment = .center
        label.textColor = UIColor().getPrimaryPinkDark()
        label.font =  UIFont(name: "Lato-Regular", size: 14)
        return label
    }()
    
    var conversation : Conversation? {
        didSet {
            if let seconds = conversation?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
                
            }
            var fromId = conversation?.fromId
            if fromId == Auth.auth().currentUser?.uid {
                guard let id = conversation?.conversationParnerId() else {return}
                getUserName(uid: id)
                self.backgroundColor = .white
            }else {
                guard let id = fromId else {return}
                getUserName(uid: id)
                self.backgroundColor = .yellow
            }
            
            temperatureLabel.text = conversation?.recordedTemperature
            humidityLabel.text = conversation?.recordedHumidity
            heartBeatLabel.text = conversation?.recordedHeartBeat
        }
    }
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 9)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        setUpLayout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getUserName(uid : String) {
        
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictonnary = snapshot.value as? [String : Any] {
                self.profileName.text = dictonnary["displayName"] as? String
                guard let link = dictonnary["photoUrl"] as? String else {
                    return
                }
                self.profileImageView.downloadedFrom(link: link)
            }
            
        }, withCancel: nil)
      
    }
    func setUpLayout(){
        
        profileImageView.layer.cornerRadius = 30
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        let imagesSize : CGFloat = 40
        profileName.font =  UIFont(name: "Lato-Regular", size: 14)
        // buttonStackView.addArrangedSubview(chatButton)
        heartBeatViewContainer.addSubview(heartBeatImageView)
        heartBeatViewContainer.addSubview(heartBeatLabel)
        
        heartBeatImageView.topAnchor.constraint(equalTo: heartBeatViewContainer.topAnchor, constant: 0).isActive = true
        //heartBeatImageView.leadingAnchor.constraint(equalTo: heartBeatViewContainer.leadingAnchor, constant: 0).isActive = true
        //heartBeatImageView.trailingAnchor.constraint(equalTo: heartBeatViewContainer.trailingAnchor, constant: 0).isActive = true
        heartBeatImageView.centerXAnchor.constraint(equalTo: heartBeatViewContainer.centerXAnchor, constant: 0).isActive = true
        heartBeatImageView.heightAnchor.constraint(equalToConstant: imagesSize).isActive = true
        heartBeatImageView.widthAnchor.constraint(equalToConstant: imagesSize).isActive = true
        heartBeatLabel.topAnchor.constraint(equalTo: heartBeatImageView.bottomAnchor, constant: 0).isActive = true
        heartBeatLabel.trailingAnchor.constraint(equalTo: heartBeatImageView.trailingAnchor, constant: 0).isActive = true
        heartBeatLabel.leadingAnchor.constraint(equalTo: heartBeatImageView.leadingAnchor, constant: 0).isActive = true
        heartBeatLabel.bottomAnchor.constraint(equalTo: heartBeatViewContainer.bottomAnchor, constant: 0).isActive = true
        heartBeatLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
     
        humidityViewContainer.addSubview(humidityImageView)
        humidityViewContainer.addSubview(humidityLabel)
        
        humidityImageView.topAnchor.constraint(equalTo: humidityViewContainer.topAnchor, constant: 0).isActive = true
        //humidityImageView.leadingAnchor.constraint(equalTo: humidityViewContainer.leadingAnchor, constant: 0).isActive = true
        //humidityImageView.trailingAnchor.constraint(equalTo: humidityViewContainer.trailingAnchor, constant: 0).isActive = true
        humidityImageView.centerXAnchor.constraint(equalTo: humidityViewContainer.centerXAnchor, constant: 0).isActive = true
        humidityImageView.heightAnchor.constraint(equalToConstant: imagesSize).isActive = true
        humidityImageView.widthAnchor.constraint(equalToConstant: imagesSize).isActive = true
        humidityLabel.topAnchor.constraint(equalTo: humidityImageView.bottomAnchor, constant: 0).isActive = true
        humidityLabel.trailingAnchor.constraint(equalTo: humidityImageView.trailingAnchor, constant: 0).isActive = true
        humidityLabel.leadingAnchor.constraint(equalTo: humidityImageView.leadingAnchor, constant: 0).isActive = true
        humidityLabel.bottomAnchor.constraint(equalTo: humidityViewContainer.bottomAnchor, constant: 0).isActive = true
        humidityLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        temperatureViewContainer.addSubview(temperatureImageView)
        temperatureViewContainer.addSubview(temperatureLabel)
        
        temperatureImageView.topAnchor.constraint(equalTo: temperatureViewContainer.topAnchor, constant: 0).isActive = true
        //temperatureImageView.leadingAnchor.constraint(equalTo: temperatureViewContainer.leadingAnchor, constant: 0).isActive = true
        //temperatureImageView.trailingAnchor.constraint(equalTo: temperatureViewContainer.trailingAnchor, constant: 0).isActive = true
        temperatureImageView.centerXAnchor.constraint(equalTo: temperatureViewContainer.centerXAnchor, constant: 0).isActive = true
        temperatureImageView.heightAnchor.constraint(equalToConstant: imagesSize).isActive = true
        temperatureImageView.widthAnchor.constraint(equalToConstant: imagesSize).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: temperatureImageView.bottomAnchor, constant: 0).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: 0).isActive = true
        temperatureLabel.leadingAnchor.constraint(equalTo: temperatureImageView.leadingAnchor, constant: 0).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: temperatureViewContainer.bottomAnchor, constant: 0).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //timeLabel.trailingAnchor.constraint(equalTo: dataCapteurStackView.trailingAnchor).isActive = true
       // timeLabel.centerYAnchor.constraint(equalTo: dataCapteurStackView.centerYAnchor).isActive = true
        //timeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dataCapteurStackView.addArrangedSubview(heartBeatViewContainer)
        dataCapteurStackView.addArrangedSubview(temperatureViewContainer)
        dataCapteurStackView.addArrangedSubview(humidityViewContainer)
        dataCapteurStackView.addArrangedSubview(timeLabel)

        
        dataCapteurStackView.distribution = .fillEqually
        dataCapteurStackView.spacing = 15
    }
    
}
