//
//  AppDelegate.swift
//  FlashLuv
//
//  Created by Isma Dia on 13/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuthUI
import GoogleSignIn
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
         IQKeyboardManager.shared.enable = true
        // Override point for customization after application launch
        FirebaseApp.configure()
        
        //Google sign in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
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
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
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
        //handleDeeplink(url: url)
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
            var flirts : Int?
            var likes : Int?
            var views : Int?
            
           /* usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : Any] {
                    flirts = dictionary["flirts"] as? Int
                    likes = dictionary["likes"] as? Int
                    views = dictionary["views"] as? Int
                    if( flirts == nil){
                        flirts = 0
                    }
                    if( likes == nil){
                        likes = 0
                    }
                    if( views == nil){
                        views = 0
                    }
                }
            }, withCancel: nil)*/
            
            
            let imageUrl = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 400).absoluteString
            let values = ["uid": uid,"displayName" : user?.displayName, "email": user?.email, "photoUrl" : imageUrl, "views": 0, "likes": 0, "flirts" : 0, "single" : false,"description" :"","age" : "","picture" : "","profileCompleted" : false, "heartbeat" : "", "humidity" : "", "temperature" : ""] as [String : Any]
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

   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        //super.application(application,didReceiveRemoteNotification:userInfo);
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
    }
    
   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                              fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        //super.application(application,didReceiveRemoteNotification:userInfo,fetchCompletionHandler:completionHandler);
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
    let notificationTitle = "Flash alert"
    
    print(notificationTitle)
    print(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }
    print(userInfo["flashedUserId"])
    guard let userId = userInfo["flashedUserId"] as? String else {
        return
    }
    print(userId)
    let conversationId =  userInfo["conversationId"] as? String
    handleDeeplink(title : notificationTitle, uid : userId, conversationId: conversationId)
    // Print full message.
    print(userInfo)
    
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        //Messaging.messaging().apnsToken = deviceToken
    }
    
    func handleDeeplink(title : String, uid : String, conversationId : String?){
        if (title == "Flash alert"){
            let profileViewController = ProfileViewController()
            profileViewController.uid = uid
            let tabBar = FlashLuvTabBarController()
            window?.rootViewController?.present(tabBar, animated: false, completion: {
        tabBar.userConnectedProfileViewController.pushViewController(profileViewController, animated: true)
            })
            
            
        }
        if (title == "Quiz alert"){
            /*let quizAnswersViewController = QuizzAnswerViewController()
            guard let convId = conversationId else {return}
            quizAnswersViewController.conversationId = convId*/
            let conversationByUser = ConversationByUserViewController()
            conversationByUser.userId = uid
            let tabBar = FlashLuvTabBarController()
            window?.rootViewController?.present(tabBar, animated: false, completion: {
                tabBar.userConnectedProfileViewController.pushViewController(conversationByUser, animated: true)
            })
        }
        
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let notificationBody = response.notification.request.content.body
        let notificationTitle = response.notification.request.content.title
        print(notificationTitle)
        print(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo["flashedUserId"])
        guard let userId = userInfo["flashedUserId"] as? String else {
            return
        }
        print(userId)
        let conversationId =  userInfo["conversationId"] as? String
        handleDeeplink(title : notificationTitle, uid : userId, conversationId: conversationId)
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference(fromURL: "https://flashloveapi.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        //let values = ["name" : name, "email": email , "age": 10] as [String : Any]
        let values = ["fcmToken" : fcmToken] as [String : Any]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("User Modified")
        })
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}






