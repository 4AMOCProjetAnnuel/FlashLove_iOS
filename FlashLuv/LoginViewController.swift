//
//  LoginViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 29/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    let inputsContainerView : UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.axis = .vertical
        view.distribution = .fillEqually
        //view.layer.cornerRadius = 5
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nom"
        return textField
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Mot de passe"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let ageTextField : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Age"
        textField.isSecureTextEntry = false
        return textField
    }()
    
    let descriptionTextView : UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.isEditable = true
        label.text = "Description"
        label.font = UIFont(name: "Lato-Regular", size: 17)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    let registerButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor().getPrimaryPinkDark(), for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.2
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let loginRegisterSegemnetedControl : UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Login", "Register"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.selectedSegmentIndex = 1
        seg.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return seg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().getPrimaryPinkDark()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupLoginLayout()
        setupLoginRegisterSegemnetedControl()
        setupGoogleSignInButton()
        
    }
    
    func setupLoginRegisterSegemnetedControl() {
        scrollView.addSubview(loginRegisterSegemnetedControl)
        
        loginRegisterSegemnetedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegemnetedControl.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        loginRegisterSegemnetedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -20).isActive = true
        loginRegisterSegemnetedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegemnetedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        loginRegisterSegemnetedControl.tintColor = .white

    }
    
    @objc func handleLoginRegisterChanged() {
        let title = loginRegisterSegemnetedControl.titleForSegment(at: loginRegisterSegemnetedControl.selectedSegmentIndex)
        registerButton.setTitle(title, for: .normal)
        
        let height = loginRegisterSegemnetedControl.selectedSegmentIndex == 0 ? 100 : 400
        //inputsContainerView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        inputsContainerViewHeightAnchor?.constant = CGFloat(height)
        if loginRegisterSegemnetedControl.selectedSegmentIndex == 0 {
            inputsContainerView.removeArrangedSubview(nameTextField)
            inputsContainerView.removeArrangedSubview(ageTextField)
            inputsContainerView.removeArrangedSubview(descriptionTextView)
            nameTextField.heightAnchor.constraint(equalToConstant: 0).isActive = true
            ageTextField.heightAnchor.constraint(equalToConstant: 0).isActive = true
            descriptionTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true

        }else{
            inputsContainerView.insertArrangedSubview(nameTextField, at: 0)
            inputsContainerView.insertArrangedSubview(ageTextField, at: 3)
            inputsContainerView.insertArrangedSubview(descriptionTextView, at: 4)
            

        }
    }
    
    
    func setupGoogleSignInButton(){
        let googleSignInButton = GIDSignInButton()
        //googleSignInButton.addTarget(self, action: #selector(callSignInGoogle), for: .touchUpInside)
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(googleSignInButton)
        googleSignInButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20).isActive = true
        googleSignInButton.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 0).isActive = true
        googleSignInButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 0).isActive = true
        //googleSignInButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        googleSignInButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10) .isActive = true

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().signOut()
    }
    
    @objc func callSignInGoogle(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    var inputsContainerViewHeightAnchor : NSLayoutConstraint?
    
    
    func setupLoginLayout() {
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(inputsContainerView)
        scrollView.addSubview(registerButton)
        //Touch outside to dismiss the keyboard
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss)))
        

        inputsContainerView.addArrangedSubview(nameTextField)
        inputsContainerView.addArrangedSubview(emailTextField)
        inputsContainerView.addArrangedSubview(passwordTextField)
        inputsContainerView.addArrangedSubview(ageTextField)
        inputsContainerView.addArrangedSubview(descriptionTextView)
       
        //inputsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 400)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        
        registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 20).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 0).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 0).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 75)

    }
    
    @objc func handleLoginRegister() {
        if loginRegisterSegemnetedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    @objc func handleLogin() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {
                print("form unvalid")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (User, error) in
            if error != nil {
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
            print("User logged in")
        }
    }
    
    @objc func handleRegister() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
            print("form unvalid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (User, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = User?.uid else {
                return
            }
            let ref = Database.database().reference(fromURL: "https://flashloveapi.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            //let values = ["name" : name, "email": email , "age": 10] as [String : Any]
            let values = ["uid": uid,"displayName" : name, "email": email, "single" : false, "description" :self.descriptionTextView.text,"age" : self.ageTextField.text,"picture" : "","profileCompleted" : false,"photoUrl": "",
                          "views": 0,
                          "likes": 0,
                          "flirts":0
                ] as [String : Any]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                print("User saved")
            })
            
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //This is for the keyboard to GO AWAYY !! when user clicks anywhere on the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func keyboardDismiss(){
        
        self.view.endEditing(true)
        
    }
    
    
}
