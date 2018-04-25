//
//  ViewController.swift
//  FlashLuv
//
//  Created by Isma Dia on 13/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let label = UILabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendToProfilePicture(_ sender: Any) {
        
        present(ProfileViewController(), animated: true, completion: nil)
    }
    
}

