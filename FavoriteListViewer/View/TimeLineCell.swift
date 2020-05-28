//
//  TimeLineCell.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class TweetViewCell: UITableViewCell {
    
    private var userIcon: UIImageView!  //ユーザアイコン
    private var userName: UILabel!      //ユーザ名
    private var userID: UILabel!        //ユーザID
    private var tweetContent: UILabel!  //ツイート内容
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userIcon = UIImageView()
        userIcon.backgroundColor = .blue
        contentView.addSubview(userIcon)
        userName = UILabel()
        userName.backgroundColor = .yellow
        contentView.addSubview(userName)
        userID = UILabel()
        userID.backgroundColor = .red
        contentView.addSubview(userID)
        tweetContent = UILabel()
        tweetContent.backgroundColor = .orange
        contentView.addSubview(tweetContent)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        userIcon.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        userIcon.layer.cornerRadius = 25
        userName.frame = CGRect(x: userIcon.frame.maxX + 5, y: 5, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 20)
        userID.frame = CGRect(x: userIcon.frame.maxX + 5, y: 25, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 20)
        tweetContent.frame = CGRect(x: userIcon.frame.maxX + 5, y: 45, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 100)
    }
}
