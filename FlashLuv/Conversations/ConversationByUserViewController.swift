
//  ConversationByUserViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 14/07/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//
import UIKit
import Firebase

class ConversationByUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var conversationByUserTableView: UITableView!
    
    @IBOutlet weak var conversationSegmentedControl: UISegmentedControl!
    var userId : String?
    let cellId = "byUser"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversationByUserTableView.delegate = self
        conversationByUserTableView.dataSource = self
        let nib = UINib(nibName: "ConversationByUserTableViewCell", bundle: nil)
        conversationByUserTableView.register(nib, forCellReuseIdentifier: cellId)
        observeConversation()
        
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch conversationSegmentedControl.selectedSegmentIndex {
        case 0:
            conversations.removeAll()
            observeConversation()
        case 1:
            conversations.removeAll()
            observeConversation()
        case 2: observeConversation()
        default:
            print("bla")
        }
    }
    var conversations = [Conversation]()
    func observeConversation() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userConversationsRef = Database.database().reference().child("user-conversations").child(uid)
        userConversationsRef.observe(.childAdded, with: { (snapshot) in
            let conversationId = snapshot.key
            let conversationsRef = Database.database().reference().child("conversations").child(conversationId)
            conversationsRef.observe(.value, with: { (snapshot) in
                if let dictionnary = snapshot.value as? [String : Any] {
                    guard let fromId = dictionnary["fromId"] as? String,
                        let timestamp = dictionnary["timestamp"] as? NSNumber,
                        let toId = dictionnary["toId"] as? String,
                        let humidity = dictionnary["recordedHumidity"] as? String,
                        let temperature = dictionnary["recordedTemperature"] as? String,
                        let heartbeat = dictionnary["recordedHeartBeat"] as? String
                        else {
                            return
                    }
                     let conversation = Conversation(fromId: fromId, timestamp: timestamp, toId: toId, recordedHeartBeat: heartbeat, recordedHumidity : humidity ,recordedTemperature : temperature , quiz: [])
                   conversation.conversationId = conversationId
                    if conversation.conversationParnerId() == self.userId {
                        if (self.conversationSegmentedControl.selectedSegmentIndex == 1 && conversation.fromId == Auth.auth().currentUser?.uid) {
                            self.conversations.append(conversation)
                        } else if (self.conversationSegmentedControl.selectedSegmentIndex == 0 && conversation.fromId != Auth.auth().currentUser?.uid) {
                            self.conversations.append(conversation)
                        }
                        //self.conversations.append(conversation)
                        self.conversationByUserTableView.reloadData()
                    }
                    
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationByUserTableViewCell
        let conversation = conversations[indexPath.row]
        cell.conversation = conversation
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizzAnswerViewController = QuizzAnswerViewController()
        let conversation = conversations[indexPath.row]
        quizzAnswerViewController.uid = conversation.toId
        quizzAnswerViewController.conversationId = conversation.conversationId
        quizzAnswerViewController.fromFlirts = true
        navigationController?.pushViewController(quizzAnswerViewController, animated: true)
    }
    
    
}

