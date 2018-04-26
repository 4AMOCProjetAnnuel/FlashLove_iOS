//
//  ProfileViewController.swift
//  FlashLuv
//
//  Created by Ismaël Diallo on 24/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Jhéne Colombo"
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont(name: "Lato-Bold", size: 22)
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Paris, France"
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont(name: "Lato-Regular", size: 18)
        return label
    }()
    
    let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    let buttonStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.image = UIImage(named: "jhene")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let likeButton : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Like", for: .normal)
        button.tintColor = .darkGray
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.darkGray.cgColor
        return button
    }()
    
    let chatButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Chat", for: .normal)
        button.tintColor = .darkGray
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.darkGray.cgColor
        return button
    }()
    
    let descriptionLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "Sed porttitor lectus nibh. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Donec rutrum congue leo eget malesuada. Donec rutrum congue leo eget malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula. Sed porttitor lectus nibh. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Donec rutrum congue leo eget malesuada. Donec rutrum congue leo eget malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula. "
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

    }
    
    func setupLayout(){
        navigationItem.title = "Profile"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(buttonStackView)
        scrollView.addSubview(descriptionLabel)
       

        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        profileImageView.layer.cornerRadius = 5
        profileImageView.contentMode = .scaleToFill
        
        

        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20).isActive = true
        
        buttonStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20).isActive = true
        
        
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(chatButton)
    
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        
        chatButton.addTarget(self, action: #selector(chatLogController), for: .touchUpInside)

    }
    
    @objc func chatLogController(){
    
        navigationController?.pushViewController(ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
}
