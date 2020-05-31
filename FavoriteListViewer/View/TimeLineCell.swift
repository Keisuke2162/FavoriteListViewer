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
    private var mediaView: UIImageView! //画像
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userIcon = UIImageView()
        userIcon.backgroundColor = .blue
        contentView.addSubview(userIcon)
        userName = UILabel()
        contentView.addSubview(userName)
        userID = UILabel()
        userID.textColor = .gray
        contentView.addSubview(userID)
        mediaView = UIImageView()
        mediaView.backgroundColor = .orange
        contentView.addSubview(mediaView)
        tweetContent = UILabel()
        tweetContent.numberOfLines = 0
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
        mediaView.frame = CGRect(x: 0, y: 60, width: contentView.frame.width, height: contentView.frame.width)
        tweetContent.frame = CGRect(x: userIcon.frame.maxX + 5, y: mediaView.frame.maxY + 5, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 100)
        tweetContent.sizeToFit()
    }
    
    func settingCellContent(name: String, id: String, content: String, media: String?) {
        userName.text = name
        userID.text = id
        tweetContent.text = content
        if let image = media {
            mediaView.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.width)
            mediaView.image = UIImage(url: image)
        } else {
            mediaView.frame.size = CGSize(width: 0, height: 0)
        }
    }
    
    var tweet: Tweet? {
        didSet {
            guard let tweet = tweet else { return }
            
            userIcon.image = tweet.icon
            userID.text = tweet.id
            userName.text = tweet.name
            tweetContent.text = tweet.context
            if tweet.images.count != 0 {
                mediaView.image = tweet.images[0]
            }
            
        }
    }
}
