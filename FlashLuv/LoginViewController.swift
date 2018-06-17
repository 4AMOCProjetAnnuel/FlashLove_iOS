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
    
    let inputsContainerView : UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.axis = .vertical
        view.distribution = .fillEqually
        view.layer.cornerRadius = 5
        return view
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        return textField
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email address"
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let registerButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red:0.06, green:0.39, blue:0.78, alpha:1)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
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
        view.backgroundColor = UIColor(red:0.06, green:0.3, blue:0.73, alpha:1)
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupLoginLayout()
        setupLoginRegisterSegemnetedControl()
        setupGoogleSignInButton()
        
    }
    
    func setupLoginRegisterSegemnetedControl() {
        view.addSubview(loginRegisterSegemnetedControl)
        
        loginRegisterSegemnetedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegemnetedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -20).isActive = true
        loginRegisterSegemnetedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegemnetedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        loginRegisterSegemnetedControl.tintColor = .white

    }
    
    @objc func handleLoginRegisterChanged() {
        let title = loginRegisterSegemnetedControl.titleForSegment(at: loginRegisterSegemnetedControl.selectedSegmentIndex)
        registerButton.setTitle(title, for: .normal)
        
        let height = loginRegisterSegemnetedControl.selectedSegmentIndex == 0 ? 100 : 150
        //inputsContainerView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        inputsContainerViewHeightAnchor?.constant = CGFloat(height)
        if loginRegisterSegemnetedControl.selectedSegmentIndex == 0 {
            inputsContainerView.removeArrangedSubview(nameTextField)
            nameTextField.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }else{
            inputsContainerView.insertArrangedSubview(nameTextField, at: 0)

        }
    }
    
    
    func setupGoogleSignInButton(){
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleSignInButton)
        googleSignInButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20).isActive = true
        googleSignInButton.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 0).isActive = true
        googleSignInButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 0).isActive = true
        googleSignInButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().signOut()
    }
    var inputsContainerViewHeightAnchor : NSLayoutConstraint?
    
    
    func setupLoginLayout() {
        print(Auth.auth().currentUser?.uid)

        inputsContainerView.addArrangedSubview(nameTextField)
        inputsContainerView.addArrangedSubview(emailTextField)
        inputsContainerView.addArrangedSubview(passwordTextField)
        view.addSubview(inputsContainerView)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        view.addSubview(registerButton)
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
            let ref = Database.database().reference(fromURL: "https://tutoswift.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name" : name, "email": email , "age": "10"]
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
    
}
