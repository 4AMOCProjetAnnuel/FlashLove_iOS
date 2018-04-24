//
//  ProfileViewController.swift
//  FlashLuv
//
//  Created by Ismaël Diallo on 24/04/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    
    let label1 : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Test top'zer"
        l.backgroundColor = .cyan
        return l
    }()
    
    let label2 : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Test bottom'zer"
        l.backgroundColor = .yellow
        return l
    }()
    
    let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .purple
        return sv
    }()
    
    let buttonStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        return stackView
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

    }
    
    func setupLayout(){
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        //scrollView.addSubview(label1)
        //scrollView.addSubview(label2)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(buttonStackView)
        
        /*label1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        //label1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        label1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        label1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        
        label2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 1000).isActive = true
        label2.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25).isActive = true
        label2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        label2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true*/
        
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        //profileImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25).isActive = true
        //profileImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        //profileImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true

        
        buttonStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 1000).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        
        buttonStackView.addArrangedSubview(label1)
        buttonStackView.addArrangedSubview(label2)

    }
}
