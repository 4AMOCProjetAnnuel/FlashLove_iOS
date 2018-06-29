//
//  QuizzAnswerViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 29/06/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase

class QuizzAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var quizzViewTitle: UILabel!
    @IBOutlet weak var quizzDescription: UILabel!
    
    @IBOutlet weak var questionsTableView: UITableView!
    let cellId = "questionscell"
    var uid : String? = String()
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
    }
    
    func getUserInfoFromFirebase() {
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let uid = uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            if let userFieldDictionnary = snapshot.value as? [String: Any]{
                guard let displayName = userFieldDictionnary["displayName"] as? String else {
                    return
                }
                self.quizzViewTitle.text = "Bienvenue sur le Quizz de \(displayName)"
                /*self.nameLabel.text = userFieldDictionnary["displayName"] as? String
                self.descriptionLabel.text = userFieldDictionnary["description"] as? String
                self.mailLabel.text = userFieldDictionnary["email"] as? String
                guard let views = userFieldDictionnary["views"] as? Int else {
                    return
                }
                self.numberOfViewLabel.text = "\(views)"
                guard let likes = userFieldDictionnary["likes"] as? Int else {
                    return
                }
                self.numberOfLikeLabel.text = "\(likes)"
                guard let ageInt = userFieldDictionnary["age"] as? Int else {
                    return
                }
                let ageString = "\(ageInt) ans"
                if (userFieldDictionnary["single"] as? Bool)! {
                    var celibataire = "Célibataire, "
                    celibataire.append(ageString)
                    self.situationLabel.text = celibataire
                }else {
                    var couple = "En couple, "
                    couple.append(ageString)
                    self.situationLabel.text = couple
                }
                guard let link = userFieldDictionnary["photoUrl"] as? String else {
                    return
                }
                self.profileImageView.downloadedFrom(link: link)*/
            }
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! QuestionsTableViewCell
        return cell
    }

}
