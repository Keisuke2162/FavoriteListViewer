//
//  CategoryViewController.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/06/16.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: view.frame.height * 0.1, width: view.frame.width, height: view.frame.height * 0.85)
        tableView.backgroundColor = .orange
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        //カテゴリ決定ボタン表示
        
        
        //カテゴリ一覧取得
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width * 0.2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.backgroundColor = .blue
        cell.textLabel?.text = "A"
        cell.imageView?.frame.size = CGSize(width: 10, height: 10)
        cell.imageView?.image = UIImage(named: "swan")
        
        return cell
    }
    
    
}
