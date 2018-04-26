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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendToProfilePicture(_ sender: Any) {
        let navigationController = UINavigationController(rootViewController: ProfileViewController())
        present(navigationController, animated: true, completion: nil)
    }
    
}

