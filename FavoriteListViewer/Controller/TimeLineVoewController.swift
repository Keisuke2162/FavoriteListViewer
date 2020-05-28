//
//  TimeLineVoewController.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class TimelineViewController: UIViewController {
    
    var backgroundColor: String?    //ヘッダーの色
    var iconImage: String?          //アイコン
    var tableView: UITableView!     //タイムライン部
    var token: String!              //トークンID
    var secret: String!             //シークレットID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        //UI設計
        settingUI()
        
        
        
    }
    
    func settingUI() {
        //ヘッダー
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        if let color = backgroundColor {
            header.backgroundColor = UIColor(colorCode: color)
        } else {
            //背景色データがない
        }
        let iconImageView = UIImageView()
        iconImageView.frame.size = CGSize(width: 40, height: 40)
        iconImageView.center = CGPoint(x: header.frame.width / 2, y: header.frame.height / 2 + 10)
        if let icon = iconImage {
            iconImageView.image = UIImage(named: icon)
        } else {
            //アイコン画像がない
        }
        header.addSubview(iconImageView)
        view.addSubview(header)
        
        //戻るボタン
        let returnButton = UIButton()
        returnButton.frame = CGRect(x: self.view.frame.width - 50, y: 25, width: 40, height: 40)
        returnButton.setImage(UIImage(named: "down"), for: .normal)
        returnButton.addTarget(self, action: #selector(TappedReturnButton), for: .touchUpInside)
        header.addSubview(returnButton)
        
        //タイムライン（tableView）
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: header.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - header.frame.maxY)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TweetViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
    }
    
    //Twitterデータ取得
    func getLikesData() {
        let timelineData = TimeLineDataSource(token: token, secret: secret)
        timelineData.getTimeLine()
    }
    
    @objc func TappedReturnButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TweetViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
}
