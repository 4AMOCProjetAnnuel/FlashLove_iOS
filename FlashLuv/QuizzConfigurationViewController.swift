//
//  QuizzConfigurationViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 29/06/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

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
    
    @objc func registerModificationsToFirebase() {
    print("test zer")
    }

}
