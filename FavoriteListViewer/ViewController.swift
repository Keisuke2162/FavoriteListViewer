//
//  ViewController.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let authButton = UIButton()
        authButton.frame.size = CGSize(width: 50, height: 50)
        authButton.center = self.view.center
        authButton.backgroundColor = .black
        authButton.addTarget(self, action: #selector(TappedAuth), for: .touchUpInside)
        view.addSubview(authButton)
    }
    
    @objc func TappedAuth() {
        print("tapped")
        let auth = TwitterAuth()
        auth.authTwitter()
    }
    
    

}

