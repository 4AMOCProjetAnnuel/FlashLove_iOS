//
//  ProfileViewController.swift
//  FlashLuv
//
//  Created by Ismaël Diallo on 24/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

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
    
    let situationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Célibataire, 23 ans"
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Lato-Bold", size: 16)
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
    
    let quizzButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor().getPrimaryPinkDark()
        button.setTitle("Quizz", for: .normal)
        button.tintColor = .white
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    var uid : String? = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        setupLayout()
        getUserInfoFromFirebase()

    }
    @objc func handleLogout(){
        
        do {
            try Auth.auth().signOut()
            let loginViewController = LoginViewController()
            present(loginViewController, animated: true, completion: nil)
        }catch let signoutError {
            print(signoutError)
        }
 
    }
    
    func setupLayout(){
        navigationItem.title = "Profile"
        navigationController?.navigationBar.barTintColor = UIColor().getPrimaryPinkDark()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(situationLabel)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(buttonStackView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(quizzButton)
       

        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        profileImageView.contentMode = .scaleAspectFit
        
        situationLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10).isActive = true
        situationLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 0).isActive = true
        situationLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -view.frame.width/2).isActive = true
        

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
        descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20).isActive = true
        
        quizzButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        quizzButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        quizzButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20).isActive = true
        quizzButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20).isActive = true
        
        
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(chatButton)
    
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        
        chatButton.addTarget(self, action: #selector(chatLogController), for: .touchUpInside)

    }
    
    func getUserInfoFromFirebase() {
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let uid = uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            if let userFieldDictionnary = snapshot.value as? [String: Any]{
                self.navigationItem.title = userFieldDictionnary["displayName"] as? String
                self.nameLabel.text = userFieldDictionnary["displayName"] as? String
               // self.emailTextView.text = userFieldDictionnary["email"] as? String
                //self.ageTextField.text = userFieldDictionnary["age"] as? String
                self.descriptionLabel.text = userFieldDictionnary["description"] as? String
            }
        }, withCancel: nil)
    }
    
    
    @objc func chatLogController(){
    
       // navigationController?.pushViewController(ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        navigationController?.pushViewController(UserConnectedProfileViewController(), animated: false)
    }
}
