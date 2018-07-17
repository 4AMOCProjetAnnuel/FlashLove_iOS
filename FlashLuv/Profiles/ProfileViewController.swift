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
    
    let mailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ismadia09@gmail.com"
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
        stackView.tintColor = UIColor().getPrimaryPinkDark()
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    let numberOfViewContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let numberOfViewImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "visible")
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor().getPrimaryPinkDark()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let numberOfViewLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10000"
        label.textAlignment = .center
        label.textColor = UIColor().getPrimaryPinkDark()
        label.font =  UIFont(name: "Lato-Regular", size: 18)
        return label
    }()
    
    let likeContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let numberOfLikeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10000"
        label.textAlignment = .center
        label.textColor = UIColor().getPrimaryPinkDark()
        label.font =  UIFont(name: "Lato-Regular", size: 18)
        return label
    }()
    
    let likeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        let origImage = UIImage(named: "thumbs_up")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageView?.tintColor = UIColor().getPrimaryPinkDark()
        return button
    }()
    
    let quizzButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor().getPrimaryPinkDark()
        button.setTitle("Répondre au Quizz", for: .normal)
        button.tintColor = .white
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    var uid : String? = String()
    var numberOflikes : Int? = Int()
    var isLiked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "shutdown"), style: .plain, target: self, action: #selector(handleLogout))
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
        scrollView.addSubview(mailLabel)
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
        
        mailLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0).isActive = true
        mailLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 0).isActive = true
        mailLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -view.frame.width/2.5).isActive = true
        situationLabel.bottomAnchor.constraint(equalTo: mailLabel.topAnchor, constant: 0).isActive = true
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
        buttonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20).isActive = true
        
        quizzButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        quizzButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        quizzButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20).isActive = true
        quizzButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20).isActive = true
        
        
       
       // buttonStackView.addArrangedSubview(chatButton)
        numberOfViewContainer.addSubview(numberOfViewImageView)
        numberOfViewContainer.addSubview(numberOfViewLabel)
        
        numberOfViewImageView.topAnchor.constraint(equalTo: numberOfViewContainer.topAnchor, constant: 0).isActive = true
        numberOfViewImageView.leadingAnchor.constraint(equalTo: numberOfViewContainer.leadingAnchor, constant: 0).isActive = true
        numberOfViewImageView.trailingAnchor.constraint(equalTo: numberOfViewContainer.trailingAnchor, constant: 0).isActive = true
        numberOfViewLabel.topAnchor.constraint(equalTo: numberOfViewImageView.bottomAnchor, constant: 0).isActive = true
        numberOfViewLabel.trailingAnchor.constraint(equalTo: numberOfViewImageView.trailingAnchor, constant: 0).isActive = true
        numberOfViewLabel.leadingAnchor.constraint(equalTo: numberOfViewImageView.leadingAnchor, constant: 0).isActive = true
        numberOfViewLabel.bottomAnchor.constraint(equalTo: numberOfViewContainer.bottomAnchor, constant: 0).isActive = true
        numberOfViewLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        likeContainer.addSubview(likeButton)
        likeContainer.addSubview(numberOfLikeLabel)
        
        likeButton.topAnchor.constraint(equalTo: likeContainer.topAnchor, constant: 0).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: likeContainer.leadingAnchor, constant: 0).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: likeContainer.trailingAnchor, constant: 0).isActive = true
        numberOfLikeLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 0).isActive = true
        numberOfLikeLabel.trailingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 0).isActive = true
        numberOfLikeLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: 0).isActive = true
        numberOfLikeLabel.bottomAnchor.constraint(equalTo: likeContainer.bottomAnchor, constant: 0).isActive = true
        numberOfLikeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        buttonStackView.addArrangedSubview(numberOfViewContainer)
        buttonStackView.addArrangedSubview(likeContainer)
    
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        
        chatButton.addTarget(self, action: #selector(chatLogController), for: .touchUpInside)
        quizzButton.addTarget(self, action: #selector(goToQuizz), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(updatelikesCount), for: .touchUpInside)

    }
    
    @objc func goToQuizz(){
        let quizzController = QuizzAnswerViewController()
        quizzController.uid = uid
        self.navigationController?.pushViewController(quizzController, animated: true)
    }
    
    func getUserInfoFromFirebase() {
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let uid = uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            if let userFieldDictionnary = snapshot.value as? [String: Any]{
                self.navigationItem.title = userFieldDictionnary["displayName"] as? String
                self.nameLabel.text = userFieldDictionnary["displayName"] as? String
                self.descriptionLabel.text = userFieldDictionnary["description"] as? String
                self.mailLabel.text = userFieldDictionnary["email"] as? String
                guard let views = userFieldDictionnary["views"] as? Int else {
                    return
                }
                self.numberOfViewLabel.text = "\(views)"
                guard let likes = userFieldDictionnary["likes"] as? Int else {
                    return
                }
                self.numberOflikes = likes
                self.numberOfLikeLabel.text = "\(likes)"
                guard let ageInt = userFieldDictionnary["age"] as? Int else {
                    return
                }
                let ageString = "\(ageInt) ans"
                if (userFieldDictionnary["single"] as? Bool)! {
                    var celibataire = "Célibataire, "
                    celibataire.append(ageString)
                    self.situationLabel.text = celibataire
                }else {
                    var couple = "En couple, "
                    couple.append(ageString)
                    self.situationLabel.text = couple
                }
                guard let link = userFieldDictionnary["photoUrl"] as? String else {
                    return
                }
                self.profileImageView.downloadedFrom(link: link)
            }
        }, withCancel: nil)
    }
    
    @objc func updatelikesCount(){
        guard let uid = uid else {return}
        let ref = Database.database().reference(fromURL: "https://flashloveapi.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        var currentNumberOfLikes : Int? = 0
        
        usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                
                currentNumberOfLikes = dictionary["likes"] as? Int
                if (currentNumberOfLikes == nil) {
                    currentNumberOfLikes = 0
                }
                let counter = currentNumberOfLikes! + 1 
                let values = ["likes" : counter] as [String : Any]
                
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                    
                    print("User Modified")
                })
            }
        }, withCancel: nil)
        
     
       
        
    }
    
    @objc func chatLogController(){
        navigationController?.pushViewController(UserConnectedProfileViewController(), animated: false)
    }
}
