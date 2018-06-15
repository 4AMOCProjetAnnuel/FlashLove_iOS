//
//  ConversationTableViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 29/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase

class ConversationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "see profile", style: .plain, target: self, action: #selector(seeProfile))
        
        checkIfUserIsLogdedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfUserIsLogdedIn() {
        if Auth.auth().currentUser == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            Database.database().reference().child("users")
        }
        
    }

    
  @objc func handleLogout(){
    
    do {
        try Auth.auth().signOut()
    }catch let signoutError {
        print(signoutError)
    }
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
    }

    @objc func seeProfile(){
       // let profileViewController = UINavigationController(rootViewController: ProfileViewController())
       // present(profileViewController, animated: true, completion: nil)
        let profileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }

}
