//
//  QuestionsTableViewCell.swift
//  FlashLuv
//
//  Created by Isma Dia on 29/06/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import Firebase

class QuestionsTableViewCell: UITableViewCell, UITextViewDelegate{

    var questionId : String!
    var uid : String!
    var answer : String?
    var conversationId : String?
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var registerAnswer: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
        answerTextView.delegate = self
        registerAnswer.addTarget(self, action: #selector(setQuiz), for: .touchUpInside)
    }

    func textViewDidChange(textView: UITextView) {
        if (textView == answerTextView) {
            answer = answerTextView.text
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupView(){
        answerTextView.layer.cornerRadius = 5
        registerAnswer.layer.cornerRadius = 5
    }
    
    @objc func registerAnswerToFirebase(){
        print("register")
    }
    
@objc func setQuiz() {
        guard let id = self.conversationId else { return }
        let conversationReference = Database.database().reference().child("conversations").child(id)
        let quizReference = conversationReference.child("quiz").childByAutoId()
        guard let question = questionLabel.text,
            let reponse = answerTextView.text else {
                return
        }
        let values = ["question": question, "reponse": reponse ] as [String : Any]
        quizReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err)
                return
               
            }
        }
        
    }
    
}
