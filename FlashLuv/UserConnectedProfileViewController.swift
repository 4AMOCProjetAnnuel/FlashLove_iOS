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
        //label.isEditable = true
        //label.text = "23"
        label.placeholder = "Age"
        label.font = UIFont(name: "Lato-Regular", size: 18)
        label.textAlignment = .center
        label.keyboardType = UIKeyboardType.numbersAndPunctuation
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
    
    var userName = "User profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextView.delegate = self
        ageTextField.delegate = self
        descriptionTextView.delegate = self
        registerProfileInfoButton.addTarget(self, action: #selector(setUserInfoInDatabase), for: .touchUpInside)
        setupNavigationController()
        setupLayout()
        getUserInfoFromFirebase()
        // Do any additional setup after loading the view.
    }
    
    func getUserInfoFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            if let userFieldDictionnary = snapshot.value as? [String: Any]{
                self.nameLabel.text = userFieldDictionnary["displayName"] as? String
                self.emailTextView.text = userFieldDictionnary["email"] as? String
                self.ageTextField.text = userFieldDictionnary["age"] as? String
                self.descriptionTextView.text = userFieldDictionnary["description"] as? String
                guard let link = userFieldDictionnary["photoUrl"] as? String else {
                    return
                }
                self.profileImageView.downloadedFrom(link: link)
            }
        }, withCancel: nil)
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
        let values = ["uid": uid,"displayName" : name, "email": email, "single" : false, "description" :self.descriptionTextView.text,"age" : self.ageTextField.text,"picture" : "","profileCompleted" : false
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Public profile", style: .plain, target: self, action: #selector(seePublicProfile))
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
        scrollView.addSubview(registerProfileInfoButton)
        
        
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
        
        emailTextView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10).isActive = true
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
        
        registerProfileInfoButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10).isActive = true
        registerProfileInfoButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        registerProfileInfoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        registerProfileInfoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        registerProfileInfoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        buttonStackView.addArrangedSubview(setupProfileVisitsNumberView())
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(chatButton)
        
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
        
        // navigationController?.pushViewController(ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    
    @objc func keyboardDismiss(){
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    
}

