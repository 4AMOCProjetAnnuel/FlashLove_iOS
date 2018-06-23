//
//  AppDelegate.swift
//  FlashLuv
//
//  Created by Isma Dia on 13/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import TwitterKit
//import FBSDKCoreKit
import GoogleSignIn
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    let TWITTER_CONSUMER_KEY = "VfZ8WUCKsafBxWApoAdhoM3HU"
    let TWITTER_CONSUMER_SECRET = "PrSOruBotAoVtSmgoT4sJLdYfIbXmS9zvRLL6EBbztoVdSSw2D"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
         IQKeyboardManager.shared.enable = true
        // Override point for customization after application launch
        FirebaseApp.configure()
        
        //Google sign in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey:TWITTER_CONSUMER_KEY,
                                       consumerSecret:TWITTER_CONSUMER_SECRET)
        
        window = UIWindow(frame : UIScreen.main.bounds)
        if Auth.auth().currentUser?.uid == nil {
            window?.rootViewController = LoginViewController()
        }else{
            window?.rootViewController = FlashLuvTabBarController()
        }
        
        
        
        window?.makeKeyAndVisible()
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = UIColor().getPrimaryPinkDark()
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().backgroundColor = UIColor().getPrimaryPinkDark()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        //        if Auth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        //            return true
        //        }
        // other URL handling goes here.
        //return false
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                          annotation: [:])
        return false
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if error != nil {
            print("Failed to log in into Google")
            return
        }
        
        //guard let authentication = user.authentication else { return }
        guard let idToken = user.authentication.idToken else { return }
        guard let acccesToken = user.authentication.accessToken else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: acccesToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Fail to create a Firebase User", error)
                return
            }
            
            guard let uid = user?.uid else {return}
            print("Connecté avec cet uid", uid)
            let ref = Database.database().reference(fromURL: "https://flashloveapi.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let imageUrl = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 400).absoluteString
            let values = ["uid": uid,"displayName" : user?.displayName, "email": user?.email, "photoUrl" : imageUrl]
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                //self.dismiss(animated: true, completion: nil)
                print("User saved")
            })
            //self.window?.rootViewController =  UINavigationController(rootViewController:FlashLuvTabBarController())
            self.window?.rootViewController =  FlashLuvTabBarController()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIColor {
    
    func getPrimaryPinkDark() -> UIColor {
        return UIColor(red: 198/255, green: 0/255, blue: 85/255, alpha: 1.0)
    }
}


