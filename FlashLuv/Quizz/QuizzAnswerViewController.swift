//
//  QuizzAnswerViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 29/06/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase
//import Messages

class QuizzAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
   
    
    
    @IBOutlet weak var quizzViewTitle: UILabel!
    @IBOutlet weak var quizzDescription: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var questionsTableView: UITableView!
    let cellId = "questionscell"
    var uid : String? = String()
    var questions : [String] = []
    var reponses : [String] = []
    var quiz : [String : String] = [:]
    var conversationId : String?
    var newConversationId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        let nib = UINib(nibName: "QuestionsTableViewCell", bundle: nil)
        questionsTableView.register(nib, forCellReuseIdentifier: cellId)
        setupView()
        getUserInfoFromFirebase()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView(){
        navigationItem.title = "Quizz"
        let titleFont = UIFont(name: "Lato-Bold", size: 22)
        let descrptionFont = UIFont(name: "Lato-Bold", size: 17)
        quizzViewTitle.font = titleFont
        quizzDescription.font = descrptionFont
        saveButton.addTarget(self, action: #selector(saveAnswers), for: .touchUpInside)
    }
    
    func getUserInfoFromFirebase() {
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        
        if (conversationId == nil) {
        guard let uid = uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            if let userFieldDictionnary = snapshot.value as? [String: Any]{
                guard let displayName = userFieldDictionnary["displayName"] as? String else {
                    return
                }
                self.quizzViewTitle.text = "Bienvenue sur le Quizz de \(displayName)"
                guard let userQuestions = userFieldDictionnary["questions"] as? [String] else {
                    return
                }
                self.questions = userQuestions
                self.questionsTableView.reloadData()
            }
        }, withCancel: nil)
        createConversation()
        }else {
            guard let id = self.conversationId else { return }
            let conversationReference = Database.database().reference().child("conversations").child(id)
            let quizReference = conversationReference.child("quiz")
            quizReference.observe(.value, with: { (snapshot) in
                print(snapshot)
                if let dictionnary = snapshot.value as? [String : Any] {
                    print(snapshot)
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let key = snap.key
                        let value = snap.value
                        print("key = \(key)  value = \(value!)")
                        if let childDictionnary = value as? [String : Any] {
                        guard let question = childDictionnary["question"] as? String,
                            let reponse = childDictionnary["reponse"] as? String else {
                                return
                        }
                        self.questions.append(question)
                        self.reponses.append(reponse)
                        self.questionsTableView.reloadData()
                        }
                    }
                    
                    
                }
            }, withCancel: nil)
                    
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! QuestionsTableViewCell
        guard let uid = uid else {return cell}
        cell.uid = uid
        cell.questionLabel.text = questions[indexPath.row]
        quiz[questions[indexPath.row]] = cell.answerTextView.text
        if (conversationId != nil){
            cell.answerTextView.text = reponses[indexPath.row]
        }
        if (newConversationId != nil) {
            cell.conversationId = newConversationId
        }
        
        //cell.questionLabel.text = uid
       cell.answerTextView.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! QuestionsTableViewCell
        quiz[questions[indexPath.row]] = cell.answerTextView.text
        print(quiz)
        print("ehifhekjh")
    }
    
    
    @objc func saveAnswers(){
        //sendButton.setTitleColor(UIColor.red, for: .normal)
        let ref = Database.database().reference().child("conversations")
        let childRef = ref.childByAutoId()
        guard
            let toId = uid,
            let fromId = Auth.auth().currentUser?.uid else {return}
        let timeStamp = Date().timeIntervalSince1970 as NSNumber
        let values = ["text" : "quiz", "name" : "Jhéné Colombo", "toId" : toId, "fromId" : fromId, "timestamp": timeStamp, "recordedHeartBeat" : 50, "recordedHumidity" : 50, "recordedTemperature" : 50] as [String : Any]
        
        
        childRef.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            
            }
        for item in quiz {
            let quizRef = childRef.child("quiz").childByAutoId()
            let quizValues = ["question" : item.key  , "reponse" : item.value]
            quizRef.updateChildValues(quizValues) { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                
            }
        }
            let userConversationsRef = Database.database().reference().child("user-conversations").child(fromId)
            let conversationId = childRef.key
            userConversationsRef.updateChildValues([conversationId : 1])
            
            let recipientUserConversationsRef = Database.database().reference().child("user-conversations").child(toId)
            recipientUserConversationsRef.updateChildValues([conversationId : 1])
        }

    func createConversation() {
        let ref = Database.database().reference().child("conversations")
        let childRef = ref.childByAutoId()
        guard
            let toId = uid,
            let fromId = Auth.auth().currentUser?.uid else {return}
        let timeStamp = Date().timeIntervalSince1970 as NSNumber
        let values = ["text" : "quiz", "name" : "Jhéné Colombo", "toId" : toId, "fromId" : fromId, "timestamp": timeStamp, "recordedHeartBeat" : 50, "recordedHumidity" : 50, "recordedTemperature" : 50] as [String : Any]
        
        
        childRef.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            
        }
        let userConversationsRef = Database.database().reference().child("user-conversations").child(fromId)
        let conversationId = childRef.key
        userConversationsRef.updateChildValues([conversationId : 1])
        
        let recipientUserConversationsRef = Database.database().reference().child("user-conversations").child(toId)
        recipientUserConversationsRef.updateChildValues([conversationId : 1])
        newConversationId = conversationId
    }

}
