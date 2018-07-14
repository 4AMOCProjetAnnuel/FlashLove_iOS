//
//  FlashLuvTabBarController.swift
//  FlashLuv
//
//  Created by Isma Dia on 15/06/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class FlashLuvTabBarController: UITabBarController {
    let userConnectedProfileViewController = UINavigationController(rootViewController : UserConnectedProfileViewController())
    let photoViewController = UINavigationController(rootViewController :PhotoViewController())
    let conversationsController = UINavigationController(rootViewController: ConversationsViewController())
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        tabBar.barTintColor = UIColor().getPrimaryPinkDark()
        //let profileViewController = ProfileViewController()
        //profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(), tag: 1)
        
        
        let userConnectedTabBarImage = UIImage(named: "user_male")
        userConnectedProfileViewController.tabBarItem = UITabBarItem(title: "Profile", image: userConnectedTabBarImage, tag: 1)
        
      
        let photoTabBarImage = UIImage(named: "qr_code")
        photoViewController.tabBarItem = UITabBarItem(title: "Scan", image: photoTabBarImage, tag: 2)
        
        let conversationsImage = UIImage(named: "qr_code")
        conversationsController.tabBarItem = UITabBarItem(title: "Conversations", image: conversationsImage, tag: 3)
        
        let viewControllerList = [userConnectedProfileViewController,photoViewController,conversationsController]
        viewControllers = viewControllerList
        
    }
    
    @objc func seePublicProfile(){
        navigationController?.pushViewController(ProfileViewController(), animated: true)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
