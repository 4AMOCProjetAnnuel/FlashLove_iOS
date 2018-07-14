//
//  ConversationsViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 13/07/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ConversationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var conversationsTableView: UITableView!
    let cellId = "conversationCellId"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        conversationsTableView.delegate = self
        conversationsTableView.dataSource = self
        let nib = UINib(nibName: "ConversationsTableViewCell", bundle: nil)
        conversationsTableView.register(nib, forCellReuseIdentifier: cellId)
        setupNavigationController()
        //observeConversations()
       
    }
    var conversations = [Conversation]()
    var conversationsDictionnary = [String : Conversation]()
    func observeUserConversations(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-conversations").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let conversationId = snapshot.key
            let conversationReference = Database.database().reference().child("conversations").child(conversationId)
            conversationReference.observe(.value, with: { (snapshot) in
                print(snapshot)
                if let dictionnary = snapshot.value as? [String : Any] {
                    guard let fromId = dictionnary["fromId"] as? String,
                        let timestamp = dictionnary["timestamp"] as? NSNumber,
                        let toId = dictionnary["toId"] as? String,
                        let text = dictionnary["text"] as? String,
                        let name = dictionnary["name"] as? String else {
                            return
                    }
                    let conversation = Conversation(fromId: fromId, timestamp: timestamp, toId: toId, text: text, name: name)
                    print(snapshot)
                    //self.conversations.append(conversation)
                    self.conversationsDictionnary[toId] = conversation
                    self.conversations = Array(self.conversationsDictionnary.values)
                    self.conversations.sort(by: { (conversation1, conversation2) -> Bool in
                        guard let tsc1 = conversation1.timestamp?.intValue, let tsc2 = conversation2.timestamp?.intValue else {
                            return false
                        }
                        return tsc1 > tsc2
                    })
                    self.conversationsTableView.reloadData()
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    func observeConversations(){
        let reference = Database.database().reference().child("conversations")
        reference.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionnary = snapshot.value as? [String : Any] {
                guard let fromId = dictionnary["fromId"] as? String,
                    let timestamp = dictionnary["timestamp"] as? NSNumber,
                    let toId = dictionnary["toId"] as? String,
                    let text = dictionnary["text"] as? String,
                    let name = dictionnary["name"] as? String else {
                        return
                }
                let conversation = Conversation(fromId: fromId, timestamp: timestamp, toId: toId, text: text, name: name)
                print(snapshot)
                //self.conversations.append(conversation)
                self.conversationsDictionnary[toId] = conversation
                self.conversations = Array(self.conversationsDictionnary.values)
                self.conversations.sort(by: { (conversation1, conversation2) -> Bool in
                    guard let tsc1 = conversation1.timestamp?.intValue, let tsc2 = conversation2.timestamp?.intValue else {
                        return false
                    }
                    return tsc1 > tsc2
                })
                self.conversationsTableView.reloadData()
                
            }
        }, withCancel: nil)
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
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(chatLogController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "shutdown"), style: .plain, target: self, action: #selector(handleLogout))
        checkIfUserIsLoggedIn()
        observeUserConversations()
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationsTableViewCell
        let conversation = conversations[indexPath.row]
       cell.conversation = conversation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationByUser = ConversationByUserViewController()
        let conversation = conversations[indexPath.row]
        guard let conversationPartnerId = conversation.conversationParnerId() else {return}
        let ref = Database.database().reference().child("users").child(conversationPartnerId)
        ref.observe(.value, with: { (snapshot) in
            
        }, withCancel: nil)
        
        conversationByUser.userId = conversationPartnerId
        navigationController?.pushViewController(conversationByUser, animated: true)
    }
}
