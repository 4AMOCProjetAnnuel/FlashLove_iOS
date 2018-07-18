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
    
    
    
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var quizzViewTitle: UILabel!
    @IBOutlet weak var quizzDescription: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var questionsTableView: UITableView!
    var fromFlirts = false
    let cellId = "questionscell"
    var uid : String? = String()
    var questions : [String] = []
    var reponses : [String] = []
    var quiz : [String : String] = [:]
    var conversationId : String?
    var newConversationId : String?
    
    let heartBeatViewContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let heartBeatImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bar_chart")
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let heartBeatLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/200"
        label.textAlignment = .center
        label.textColor = .white
        label.font =  UIFont(name: "Lato-Regular", size: 14)
        return label
    }()
    
    let humidityViewContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let humidityImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "water")
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let humidityLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/200"
        label.textAlignment = .center
        label.textColor = .white
        label.font =  UIFont(name: "Lato-Regular", size: 14)
        return label
    }()
    
    let temperatureViewContainer : UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let temperatureImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "thermometer")
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let temperatureLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/200"
        label.textAlignment = .center
        label.textColor = .white
        label.font =  UIFont(name: "Lato-Regular", size: 14)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        let nib = UINib(nibName: "QuestionsTableViewCell", bundle: nil)
        questionsTableView.register(nib, forCellReuseIdentifier: cellId)
        setupView()
        getUserInfoFromFirebase()
        userImageView.backgroundColor = .yellow
        
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
        saveButton.isHidden = true
        dataStackView.backgroundColor = .white
        let imagesSize : CGFloat = 40
        
        heartBeatViewContainer.addSubview(heartBeatImageView)
        heartBeatViewContainer.addSubview(heartBeatLabel)
        
        heartBeatImageView.topAnchor.constraint(equalTo: heartBeatViewContainer.topAnchor, constant: 0).isActive = true
        //heartBeatImageView.leadingAnchor.constraint(equalTo: heartBeatViewContainer.leadingAnchor, constant: 0).isActive = true
        //heartBeatImageView.trailingAnchor.constraint(equalTo: heartBeatViewContainer.trailingAnchor, constant: 0).isActive = true
        heartBeatImageView.centerXAnchor.constraint(equalTo: heartBeatViewContainer.centerXAnchor, constant: 0).isActive = true
        heartBeatImageView.heightAnchor.constraint(equalToConstant: imagesSize).isActive = true
        heartBeatImageView.widthAnchor.constraint(equalToConstant: imagesSize).isActive = true
        heartBeatLabel.topAnchor.constraint(equalTo: heartBeatImageView.bottomAnchor, constant: 0).isActive = true
        heartBeatLabel.trailingAnchor.constraint(equalTo: heartBeatImageView.trailingAnchor, constant: 0).isActive = true
        heartBeatLabel.leadingAnchor.constraint(equalTo: heartBeatImageView.leadingAnchor, constant: 0).isActive = true
        heartBeatLabel.bottomAnchor.constraint(equalTo: heartBeatViewContainer.bottomAnchor, constant: 0).isActive = true
        heartBeatLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        humidityViewContainer.addSubview(humidityImageView)
        humidityViewContainer.addSubview(humidityLabel)
        
        humidityImageView.topAnchor.constraint(equalTo: humidityViewContainer.topAnchor, constant: 0).isActive = true
        //humidityImageView.leadingAnchor.constraint(equalTo: humidityViewContainer.leadingAnchor, constant: 0).isActive = true
        //humidityImageView.trailingAnchor.constraint(equalTo: humidityViewContainer.trailingAnchor, constant: 0).isActive = true
        humidityImageView.centerXAnchor.constraint(equalTo: humidityViewContainer.centerXAnchor, constant: 0).isActive = true
        humidityImageView.heightAnchor.constraint(equalToConstant: imagesSize).isActive = true
        humidityImageView.widthAnchor.constraint(equalToConstant: imagesSize).isActive = true
        humidityLabel.topAnchor.constraint(equalTo: humidityImageView.bottomAnchor, constant: 0).isActive = true
        humidityLabel.trailingAnchor.constraint(equalTo: humidityImageView.trailingAnchor, constant: 0).isActive = true
        humidityLabel.leadingAnchor.constraint(equalTo: humidityImageView.leadingAnchor, constant: 0).isActive = true
        humidityLabel.bottomAnchor.constraint(equalTo: humidityViewContainer.bottomAnchor, constant: 0).isActive = true
        humidityLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        temperatureViewContainer.addSubview(temperatureImageView)
        temperatureViewContainer.addSubview(temperatureLabel)
        
        temperatureImageView.topAnchor.constraint(equalTo: temperatureViewContainer.topAnchor, constant: 0).isActive = true
        //temperatureImageView.leadingAnchor.constraint(equalTo: temperatureViewContainer.leadingAnchor, constant: 0).isActive = true
        //temperatureImageView.trailingAnchor.constraint(equalTo: temperatureViewContainer.trailingAnchor, constant: 0).isActive = true
        temperatureImageView.centerXAnchor.constraint(equalTo: temperatureViewContainer.centerXAnchor, constant: 0).isActive = true
        temperatureImageView.heightAnchor.constraint(equalToConstant: imagesSize).isActive = true
        temperatureImageView.widthAnchor.constraint(equalToConstant: imagesSize).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: temperatureImageView.bottomAnchor, constant: 0).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: 0).isActive = true
        temperatureLabel.leadingAnchor.constraint(equalTo: temperatureImageView.leadingAnchor, constant: 0).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: temperatureViewContainer.bottomAnchor, constant: 0).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //timeLabel.trailingAnchor.constraint(equalTo: dataCapteurStackView.trailingAnchor).isActive = true
        // timeLabel.centerYAnchor.constraint(equalTo: dataCapteurStackView.centerYAnchor).isActive = true
        //timeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        dataStackView.addArrangedSubview(heartBeatViewContainer)
        dataStackView.addArrangedSubview(temperatureViewContainer)
        dataStackView.addArrangedSubview(humidityViewContainer)
        
        
        
        dataStackView.distribution = .fillEqually
        dataStackView.spacing = 15
    }
    
    func getUserInfoFromFirebase() {
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        
        if (conversationId == nil) {
            guard let uid = uid else {return}
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
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
                    guard let flirts = userFieldDictionnary["flirts"] as? Int else {
                        return
                    }
                    self.updateFlirtCount(uid : uid,flirts)
                    guard let link = userFieldDictionnary["photoUrl"] as? String else {
                        return
                    }
                    self.userImageView.downloadedFrom(link: link)
                    
                }
            }, withCancel: nil)
           
            
          
            Database.database().reference().child("users").child(uid).observe( DataEventType.value, with: { (snapshot) in
                print(snapshot)
                if let userFieldDictionnary = snapshot.value as? [String: Any]{
                    self.humidityLabel.text = userFieldDictionnary["humidity"] as? String
                    self.temperatureLabel.text = userFieldDictionnary["temperature"] as? String
                    self.heartBeatLabel.text = userFieldDictionnary["heartbeat"] as? String
                   
                }
            })
            createConversation()
        }else {
            guard let id = self.conversationId else { return }
            let conversationReference = Database.database().reference().child("conversations").child(id)
            conversationReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let convDictionnary = snapshot.value as? [String : Any] {
                    self.humidityLabel.text = convDictionnary["recordedHumidity"] as? String
                    self.temperatureLabel.text = convDictionnary["recordedTemperature"] as? String
                    self.heartBeatLabel.text = convDictionnary["recordedHeartBeat"] as? String
                    guard let toId = convDictionnary["toId"] as? String else {return}
                    let userReference = Database.database().reference().child("users").child(toId)
                    userReference.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let userDictionnary = snapshot.value as? [String : Any]{
                            guard let link = userDictionnary["photoUrl"] as? String else {
                                return
                            }
                            self.userImageView.downloadedFrom(link: link)
                        }
                    }, withCancel: nil)
                    
                }
                
                
            }, withCancel: nil)
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
                                let reponse = childDictionnary["response"] as? String else {
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
        return 200
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
        print(fromFlirts)
        if (fromFlirts){
            cell.registerAnswer.isHidden = true
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
    
    
    
    
    func createConversation() {
        guard
            let toId = uid,
            let fromId = Auth.auth().currentUser?.uid else {return}
        let userRef = Database.database().reference().child("users").child(toId)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userDictionnary = snapshot.value as? [String : Any] {
                
                var humidity = userDictionnary["humidity"] as? String
                if (humidity == nil || (humidity?.elementsEqual(""))!){
                    humidity = "50"
                }
                var heartbeat = userDictionnary["heartbeat"] as? String
                if (heartbeat == nil || (heartbeat?.elementsEqual(""))!) {
                    heartbeat = "50"
                }
                var temperature = userDictionnary["temperature"] as? String
                if (temperature == nil || (temperature?.elementsEqual(""))!) {
                    temperature = "50"
                }
                
                guard let link = userDictionnary["photoUrl"] as? String else {
                    return
                }
                self.userImageView.downloadedFrom(link: link)
                
                let ref = Database.database().reference().child("conversations")
                let childRef = ref.childByAutoId()
                let timeStamp = Date().timeIntervalSince1970 as NSNumber
                let values = [ "toId" : toId, "fromId" : fromId, "timestamp": timeStamp, "recordedHeartBeat" : heartbeat, "recordedHumidity" : humidity, "recordedTemperature" : temperature] as [String : Any]
                
                
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
                self.newConversationId = conversationId
                self.setNotification(conversationId: conversationId)
            }
        }, withCancel: nil)
    }
    
    func updateFlirtCount(uid : String, _ currentNumberOfFlirts: Int){
        let ref = Database.database().reference(fromURL: "https://flashloveapi.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        let counter = currentNumberOfFlirts + 1
        let values = ["flirts" : counter] as [String : Any]
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            
            print("User Modified")
        })
    }
    
    
    func setNotification(conversationId : String) {
        guard let id = uid else {return}
        Database.database().reference().child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.exists())
            if (snapshot.exists()){
                if let userFieldDictionnary = snapshot.value as? [String: Any]{
                    guard let fcmToken = userFieldDictionnary["fcmToken"] as? String else {
                        return
                    }
                    CustomNotifications.sendNotication(fcmToken: fcmToken, uid: id, from: "quizz", conversationId: conversationId)
                }
            }
        }) { (err) in
            if err != nil {
                print("user does not exist")
            }
        }
        
        
    }
}
