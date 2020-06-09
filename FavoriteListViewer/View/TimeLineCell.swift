//
//  TimeLineCell.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class TweetViewCell: UITableViewCell, UIScrollViewDelegate {
    private var userIcon: UIImageView!      //ユーザアイコン
    private var userName: UILabel!          //ユーザ名
    private var userID: UILabel!            //ユーザID
    private var tweetContent: UILabel!      //ツイート内容
    private var imageArea: UIScrollView!    //画像を表示する範囲
    private var pageControl: UIPageControl! //ページ数表示
    
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
        tweetContent = UILabel()
        tweetContent.numberOfLines = 0
        contentView.addSubview(tweetContent)
        imageArea = UIScrollView()
        imageArea.delegate = self
        imageArea.isPagingEnabled = true
        imageArea.showsHorizontalScrollIndicator = false
        contentView.addSubview(imageArea)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let image = imageArea {
            for i in image.subviews {
                i.removeFromSuperview()
            }
        }
        //imageArea.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        print("layoutSubviews")
        userIcon.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        userIcon.layer.cornerRadius = 25
        userName.frame = CGRect(x: userIcon.frame.maxX + 5, y: 5, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 20)
        userID.frame = CGRect(x: userIcon.frame.maxX + 5, y: 25, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 20)
        
        tweetContent.frame = CGRect(x: 0, y: 60, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 100)
        tweetContent.sizeToFit()
        
        //画像があれば表示する
    
        if tweet!.images.count == 0 {
             imageArea.frame = CGRect(x: 0, y: 60, width: 0, height: 0)
             imageArea.contentSize = CGSize(width: 0, height: 0)
         } else {
            imageArea!.frame = CGRect(x: 0, y: tweetContent.frame.maxY + 5, width: contentView.frame.width, height: contentView.frame.width)
            imageArea!.contentSize = CGSize(width: contentView.frame.width * CGFloat(tweet!.images.count), height: contentView.frame.width)
            
            
            for i in 0 ..< tweet!.images.count {
                let photoView = UIImageView()
                photoView.image = tweet!.images[i]
                photoView.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.width)
                photoView.center = CGPoint(x: imageArea!.frame.width / 2 * CGFloat(i * 2 + 1), y: imageArea!.frame.width / 2)
                photoView.contentMode = .scaleAspectFit
                imageArea!.addSubview(photoView)
            }
         }
        //print("imageArea width -> \(imageArea.contentSize.width)")
        
    }

    
    var tweet: Tweet? {
        didSet {
            guard let tweet = tweet else { return }
            
            userIcon.image = tweet.icon
            userID.text = "@" + tweet.id
            userName.text = tweet.name
            tweetContent.text = tweet.context
            //imageArea.contentSize = CGSize(width: 0, height: 0)
            print("Twweet")
            /*
            for i in 0 ..< tweet.images.count {
                print("setImage")
                //let aspectScale = tweet.images[i].size.height / tweet.images[i].size.width
                let photoView = UIImageView()
                photoView.contentMode = .scaleAspectFit
                photoView.image = tweet.images[i]
                photoView.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.width)
                photoView.center = CGPoint(x: imageArea.frame.width / 2 * CGFloat(i * 2 + 1), y: imageArea.frame.width / 2)
                //photoView.frame = CGRect(x: imageArea.frame.width * CGFloat(i), y: 0, width: contentView.frame.width, height: contentView.frame.width)
                
                imageArea.addSubview(photoView)
            }
            */
            print(tweet.context)
        }
    }
}
