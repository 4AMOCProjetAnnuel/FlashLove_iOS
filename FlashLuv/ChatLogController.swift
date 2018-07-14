//
//  ChatLogController.swift
//  FlashLuv
//
//  Created by Ismaël Diallo on 26/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    
    lazy var inputTextField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Entrez-votre message ici"
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        return inputTextField
    }()
    
    let sendButton : UIButton = {
        let sendButton = UIButton()
        sendButton.setTitle("Envoyer", for: .normal)
        sendButton.setTitleColor(UIColor.darkGray, for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = "Chat with Jhéné"
        setupInputComponent()
    }
    
    func setupInputComponent(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
         view.addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0) .isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
       
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 10).isActive = true
        //inputTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
    }
    
    @objc func sendMessage(){
        sendButton.setTitleColor(UIColor.red, for: .normal)
        let ref = Database.database().reference().child("conversations")
        let childRef = ref.childByAutoId()
        let values = ["text" : inputTextField.text, "name" : "Jhéné Colombo"] as [String : Any]
        childRef.updateChildValues(values)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessage()
        textField.resignFirstResponder()
        return true
    }
    
    //This is for the keyboard to GO AWAYY !! when user clicks anywhere on the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
