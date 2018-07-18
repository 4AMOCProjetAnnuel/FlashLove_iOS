//
//  UserConnectedProfileViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 22/05/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class UserConnectedProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont(name: "Lato-Bold", size: 22)
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    /*let likeButton : UIButton = {
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
    }()*/
    
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
    
    let emailTextView : UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.placeholder = "Email"
        label.font = UIFont(name: "Lato-Regular", size: 18)
        label.textAlignment = .center
        label.keyboardType = .emailAddress
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 0.2
        label.layer.borderColor = UIColor.darkGray.cgColor
        return label
    }()
    
    let ageTextField : UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.placeholder = "Age"
        label.font = UIFont(name: "Lato-Regular", size: 18)
        label.textAlignment = .center
        label.keyboardType = UIKeyboardType.numberPad
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 0.2
        label.layer.borderColor = UIColor.darkGray.cgColor
        return label
    }()
    
    let descriptionTextView : UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.isEditable = true
        label.text = "Description"
        label.font = UIFont(name: "Lato-Regular", size: 18)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 0.2
        label.layer.borderColor = UIColor.darkGray.cgColor
        return label
    }()
    
    let profileVisitsNumberContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor().getPrimaryPinkDark()
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
        
    }()
    
    let profileVisitsNumberImageView : UIImageView = {
        let view = UIImageView(image: UIImage(named: "eye"))
        view.backgroundColor = .clear
        view.tintColor = UIColor().getPrimaryPinkDark()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let profileVisitsNumberLabel : UILabel = {
        let label = UILabel()
        label.text = "10M"
        label.textColor = UIColor().getPrimaryPinkDark()
        label.textAlignment = .center
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let registerProfileInfoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor().getPrimaryPinkDark()
        button.setTitle("Enregistrer", for: .normal)
        button.tintColor = .white
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    let setupQuizzButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor().getPrimaryPinkDark()
        button.setTitle("Configurer votre Quizz", for: .normal)
        button.tintColor = .white
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.white.cgColor
        return button
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
        label.text = "0"
        label.textAlignment = .center
        label.textColor = UIColor().getPrimaryPinkDark()
        label.font =  UIFont(name: "Lato-Regular", size: 18)
        return label
    }()
    
    let numberOfFlirtsContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let numberOfFlirtsImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "feu")
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor().getPrimaryPinkDark()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let numberOfFlirtsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
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
        label.text = "0"
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
    
    let celibataireSwitch : UISwitch = {
        let celibSwitch = UISwitch()
        celibSwitch.translatesAutoresizingMaskIntoConstraints = false
        return celibSwitch
    }()
    
    let celibataireLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Célibataire ?"
        label.font =  UIFont(name: "Lato-Regular", size: 18)
        label.numberOfLines = 0
        return label
    }()
    var userName = "User profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextView.delegate = self
        ageTextField.delegate = self
        descriptionTextView.delegate = self
        registerProfileInfoButton.addTarget(self, action: #selector(setUserInfoInDatabase), for: .touchUpInside)
        setupQuizzButton.addTarget(self, action: #selector(setupQuizz), for: .touchUpInside)
        setupNavigationController()
        setupLayout()
        getUserInfoFromFirebase()
        // Do any additional setup after loading the view.
    }
    
    func getUserInfoFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let userFieldDictionnary = snapshot.value as? [String: Any]{
                self.nameLabel.text = userFieldDictionnary["displayName"] as? String
                self.emailTextView.text = userFieldDictionnary["email"] as? String
                self.ageTextField.text = userFieldDictionnary["age"] as? String
                self.descriptionTextView.text = userFieldDictionnary["description"] as? String
                guard let single = userFieldDictionnary["single"] as? Bool else {
                    return
                }
                self.celibataireSwitch.isOn = single
                guard let views = userFieldDictionnary["views"] as? Int else {
                    return
                }
                self.numberOfViewLabel.text = "\(views)"
                guard let likes = userFieldDictionnary["likes"] as? Int else {
                    return
                }
                self.numberOfLikeLabel.text = "\(likes)"
                guard let flirts = userFieldDictionnary["flirts"] as? Int else {
                    return
                }
                self.numberOfFlirtsLabel.text = "\(flirts)"
                guard let link = userFieldDictionnary["photoUrl"] as? String else {
                    return
                }
                self.profileImageView.downloadedFrom(link: link)
            }
        }, withCancel: nil)
    }
    
    @objc func setupQuizz(){
        let quizzConfigurationViewController = QuizzConfigurationViewController()
        self.navigationController?.pushViewController(quizzConfigurationViewController, animated: true)
    }
    @objc func setUserInfoInDatabase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard
            let email = emailTextView.text,
            let name = nameLabel.text else {
                print("form unvalid")
                return
        }
        let ref = Database.database().reference(fromURL: "https://flashloveapi.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        //let values = ["name" : name, "email": email , "age": 10] as [String : Any]
        let values = ["uid": uid,"displayName" : name, "email": email, "single" : celibataireSwitch.isOn, "description" :self.descriptionTextView.text,"age" : self.ageTextField.text,"picture" : "","profileCompleted" : false
            ] as [String : Any]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("User Modified")
        })
        
    }
    
    
    func setupNavigationController(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            if let userFiledDictionnary = snapshot.value as? [String: Any]{
                self.navigationItem.title = userFiledDictionnary["displayName"] as? String
            }
        }, withCancel: nil)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().getPrimaryPinkDark()
       navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(chatLogController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "shutdown"), style: .plain, target: self, action: #selector(handleLogout))
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    
    @objc func handleLogout(){
        
        do {
            GIDSignIn.sharedInstance().signOut()
            try Auth.auth().signOut()
            let loginViewController = LoginViewController()
            present(loginViewController, animated: true, completion: nil)
        }catch let signoutError {
            print(signoutError)
        }
        
    }
    
    @objc func seePublicProfile(){
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    //TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = "Description "
            textView.textColor = .lightGray
        }
    }
    
    
    //User touches outaside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupLayout(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        //Touch outside to dismiss the keyboard
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss)))
        
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(buttonStackView)
        scrollView.addSubview(emailTextView)
        scrollView.addSubview(ageTextField)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(setupQuizzButton)
        scrollView.addSubview(registerProfileInfoButton)
        scrollView.addSubview(celibataireSwitch)
        scrollView.addSubview(celibataireLabel)
        
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1).isActive = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.contentMode = .scaleToFill
        
        
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        buttonStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        celibataireSwitch.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10).isActive = true
        celibataireSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        celibataireLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10).isActive = true
        celibataireLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        ///celibataireLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        celibataireLabel.trailingAnchor.constraint(equalTo: celibataireSwitch.leadingAnchor, constant: 0)
        
      
        
        emailTextView.topAnchor.constraint(equalTo: celibataireSwitch.bottomAnchor, constant: 10).isActive = true
        //emailTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        emailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        ageTextField.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 10).isActive = true
        //ageTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        ageTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 10).isActive = true
        //descriptionTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        setupQuizzButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10).isActive = true
        //setupQuizzButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        setupQuizzButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        setupQuizzButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        setupQuizzButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        registerProfileInfoButton.topAnchor.constraint(equalTo: setupQuizzButton.bottomAnchor, constant: 10).isActive = true
        registerProfileInfoButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        registerProfileInfoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        registerProfileInfoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        registerProfileInfoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        /*buttonStackView.addArrangedSubview(setupProfileVisitsNumberView())
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(chatButton)*/
        
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
        
        numberOfFlirtsContainer.addSubview(numberOfFlirtsImageView)
        numberOfFlirtsContainer.addSubview(numberOfFlirtsLabel)
        
        numberOfFlirtsImageView.topAnchor.constraint(equalTo: numberOfFlirtsContainer.topAnchor, constant: 0).isActive = true
        numberOfFlirtsImageView.leadingAnchor.constraint(equalTo: numberOfFlirtsContainer.leadingAnchor, constant: 0).isActive = true
        numberOfFlirtsImageView.trailingAnchor.constraint(equalTo: numberOfFlirtsContainer.trailingAnchor, constant: 0).isActive = true
        numberOfFlirtsLabel.topAnchor.constraint(equalTo: numberOfFlirtsImageView.bottomAnchor, constant: 0).isActive = true
        numberOfFlirtsLabel.trailingAnchor.constraint(equalTo: numberOfFlirtsImageView.trailingAnchor, constant: 0).isActive = true
        numberOfFlirtsLabel.leadingAnchor.constraint(equalTo: numberOfFlirtsImageView.leadingAnchor, constant: 0).isActive = true
        numberOfFlirtsLabel.bottomAnchor.constraint(equalTo: numberOfFlirtsContainer.bottomAnchor, constant: 0).isActive = true
        numberOfFlirtsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        buttonStackView.addArrangedSubview(numberOfViewContainer)
        buttonStackView.addArrangedSubview(likeContainer)
        buttonStackView.addArrangedSubview(numberOfFlirtsContainer)
        
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        
        
        
        
        chatButton.addTarget(self, action: #selector(chatLogController), for: .touchUpInside)
        
    }
    
    func setupProfileVisitsNumberView() -> UIView{
        
        profileVisitsNumberContainerView.addSubview(profileVisitsNumberImageView)
        profileVisitsNumberContainerView.addSubview(profileVisitsNumberLabel)
        
        profileVisitsNumberImageView.topAnchor.constraint(equalTo: profileVisitsNumberContainerView.topAnchor, constant: 2).isActive = true
        profileVisitsNumberImageView.centerXAnchor.constraint(equalTo: profileVisitsNumberContainerView.centerXAnchor).isActive = true
        profileVisitsNumberImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        profileVisitsNumberImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        profileVisitsNumberLabel.topAnchor.constraint(equalTo: profileVisitsNumberImageView.bottomAnchor, constant: 2).isActive = true
        profileVisitsNumberLabel.leadingAnchor.constraint(equalTo: profileVisitsNumberContainerView.leadingAnchor, constant: 20).isActive = true
        profileVisitsNumberLabel.trailingAnchor.constraint(equalTo: profileVisitsNumberContainerView.trailingAnchor, constant: -20).isActive = true
        profileVisitsNumberLabel.bottomAnchor.constraint(equalTo: profileVisitsNumberContainerView.bottomAnchor, constant: 10).isActive = true
        
        return profileVisitsNumberContainerView
    }
    
    @objc func chatLogController(){
        //let chatLgocontroller = ChatLogController(collectionViewLayout : UICollectionViewFlowLayout())
        //navigationController?.pushViewController(chatLgocontroller, animated: true)
        let quizTableViewController = QuizzAnswerViewController()
        //quizTableViewController.uid = "TWF51CxJJrd11Y4Mf19ktbIRBhG3"
        //quizTableViewController.uid = "ZnNOmgLFjWZWpooR7BSb04emyID2"
        quizTableViewController.uid = "miv8L7WnmOeCQvfKGaqiJlx2nGX2"
        navigationController?.pushViewController(quizTableViewController, animated: true)
    }
    
    @objc func keyboardDismiss(){
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    
}

