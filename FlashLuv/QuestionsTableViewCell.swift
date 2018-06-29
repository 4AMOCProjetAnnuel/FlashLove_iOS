//
//  QuestionsTableViewCell.swift
//  FlashLuv
//
//  Created by Isma Dia on 29/06/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

class QuestionsTableViewCell: UITableViewCell {

    let questionId : String? = ""
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var registerAnswer: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
        registerAnswer.addTarget(self, action: #selector(registerAnswerToFirebase), for: .touchUpInside)
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
    
}
