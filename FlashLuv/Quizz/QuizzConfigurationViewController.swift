//
//  QuizzConfigurationViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 29/06/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase

class QuizzConfigurationViewController: UIViewController {
    
    
    @IBOutlet weak var quizzViewTitle: UILabel!
    @IBOutlet weak var quizzDescription: UILabel!
    
    @IBOutlet weak var question1Label: UILabel!
    @IBOutlet weak var question2Label: UILabel!
    @IBOutlet weak var question3Label: UILabel!
    @IBOutlet weak var question4Label: UILabel!
    @IBOutlet weak var question5Label: UILabel!
    
    @IBOutlet weak var question1TextField: UITextField!
    @IBOutlet weak var question2TextField: UITextField!
    @IBOutlet weak var question3TextField: UITextField!
    @IBOutlet weak var question4TextField: UITextField!
    @IBOutlet weak var question5TextField: UITextField!
    @IBOutlet weak var registerModifications: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getQuestionsFromFirebase()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupView(){
        let titleFont = UIFont(name: "Lato-Bold", size: 22)
        let descrptionFont = UIFont(name: "Lato-Bold", size: 17)
        let questionsFont = UIFont(name: "Lato-Bold", size: 14)
        quizzViewTitle.font = titleFont
        quizzDescription.font = descrptionFont
        question1Label.font = questionsFont
        question2Label.font = questionsFont
        question3Label.font = questionsFont
        question4Label.font = questionsFont
        question5Label.font = questionsFont
        
        registerModifications.layer.cornerRadius = 5
        registerModifications.addTarget(self, action: #selector(registerModificationsToFirebase), for: .touchUpInside)
    }
    
    func getQuestionsFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            if let questionsDictionnary = snapshot.value as? [String: Any]{
                let questions = questionsDictionnary["questions"] as? [String]
                self.question1TextField.text = questions?[0]
                self.question2TextField.text = questions?[1]
                self.question3TextField.text = questions?[2]
                self.question4TextField.text = questions?[3]
                self.question5TextField.text = questions?[4]
            }
        }, withCancel: nil)
    }
    @objc func registerModificationsToFirebase() {
        print("test zer")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard
            let question1 = question1TextField.text,
            let question2 = question2TextField.text,
            let question3 = question3TextField.text,
            let question4 = question4TextField.text,
            let question5 = question5TextField.text
            else {
                print("form unvalid")
                return
        }
        let questions = [question1, question2, question3, question4, question5]
        let ref = Database.database().reference(fromURL: "https://flashloveapi.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        //let values = ["name" : name, "email": email , "age": 10] as [String : Any]
        let values = ["questions" : questions] as [String : Any]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("User Modified")
        })
        
    }
    
}
