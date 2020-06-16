//
//  TimeLineCell.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

protocol CellSelectedDelegate {
    func categoryViewButtonDelegate()
}

class TweetViewCell: UITableViewCell, UIScrollViewDelegate {
    private var userIcon: UIImageView!      //ユーザアイコン
    private var userName: UILabel!          //ユーザ名
    private var userID: UILabel!            //ユーザID
    private var tweetContent: UILabel!      //ツイート内容
    private var imageArea: UIScrollView!    //画像を表示する範囲
    private var pageControl: UIPageControl! //ページ数表示
    private var ogpArea: UIScrollView!      //リンクを表示するエリア
    private var categoryButton: UIButton!   //カテゴリ選択Modalに遷移するボタン
    var delegate: CellSelectedDelegate!     //カテゴリ選択ボタン押下時に画面遷移を委託
    
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
        
        ogpArea = UIScrollView()
        ogpArea.delegate = self
        ogpArea.isPagingEnabled = true
        ogpArea.showsHorizontalScrollIndicator = false
        contentView.addSubview(ogpArea)
        
        categoryButton = UIButton()
        categoryButton.backgroundColor = .black
        categoryButton.addTarget(self, action: #selector(TapedCategoryButton), for: .touchUpInside)
        contentView.addSubview(categoryButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //画像表示エリアを初期化
        if let image = imageArea {
            for i in image.subviews {
                i.removeFromSuperview()
            }
        }
        
        /*
        //リンク表示エリアを初期化
        if let ogp = ogpArea {
            for i in ogpArea.subviews {
                i.removeFromSuperview()
            }
        }
        */
    }
    
    override func layoutSubviews() {
        //print("layoutSubviews")
        userIcon.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        userIcon.layer.cornerRadius = 25
        userName.frame = CGRect(x: userIcon.frame.maxX + 5, y: 5, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 20)
        userID.frame = CGRect(x: userIcon.frame.maxX + 5, y: 25, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 20)
        
        tweetContent.frame = CGRect(x: 0, y: 60, width: contentView.frame.width - userIcon.frame.maxX + 5, height: 100)
        tweetContent.sizeToFit()
        
        //画像があれば表示する
        if tweet!.images.count == 0 {
             imageArea.frame = CGRect(x: 0, y: tweetContent.frame.maxY + 5, width: 0, height: 0)
             imageArea.contentSize = CGSize(width: 0, height: 0)
         } else {
            imageArea!.frame = CGRect(x: 0, y: tweetContent.frame.maxY + 5, width: contentView.frame.width, height: contentView.frame.width)
            imageArea!.contentSize = CGSize(width: contentView.frame.width * CGFloat(tweet!.images.count), height: contentView.frame.width)
            
            
            for i in 0 ..< tweet!.images.count {
                let photoView = UIImageView()
                photoView.image = tweet!.images[i]
                photoView.frame.size = CGSize(width: contentView.frame.width * 0.9, height: contentView.frame.width * 0.9)
                photoView.center = CGPoint(x: imageArea!.frame.width / 2 * CGFloat(i * 2 + 1), y: imageArea!.frame.width / 2)
                photoView.layer.cornerRadius = 5.0
                photoView.layer.borderColor = UIColor.gray.cgColor
                photoView.layer.borderWidth = 1.0
                photoView.contentMode = .scaleAspectFit
                imageArea!.addSubview(photoView)
            }
         }
        
        //リンクがあればOGPで表示する
        if tweet!.linkUrls.count == 0 {
            ogpArea.frame = CGRect(x: 0, y: imageArea.frame.maxY + 5, width: 0, height: 0)
            ogpArea.contentSize = CGSize(width: 0, height: 0)
        } else {
            ogpArea.frame = CGRect(x: 0, y: imageArea.frame.maxY + 5, width: contentView.frame.width, height: contentView.frame.width / 2)
            ogpArea.contentSize = CGSize(width: contentView.frame.width * CGFloat(tweet!.linkUrls.count), height: contentView.frame.width / 2)
            
            for i in 0 ..< tweet!.linkUrls.count {
                
            }
        }
        
        categoryButton.frame = CGRect(x: contentView.frame.width * 0.8, y: imageArea.frame.maxY + 10, width: contentView.frame.width * 0.1, height: contentView.frame.width * 0.1)
        
    }

    
    var tweet: Tweet? {
        didSet {
            guard let tweet = tweet else { return }
            
            userIcon.image = tweet.icon
            userID.text = "@" + tweet.id
            userName.text = tweet.name
            tweetContent.text = tweet.context
            //imageArea.contentSize = CGSize(width: 0, height: 0)
            //print("Twweet")
            //print("LINKカウント -> \(tweet.linkUrls.count)")
            //print(tweet.context)
        }
    }
    
    //カテゴリ選択
    @objc func TapedCategoryButton() {
        print("カテゴリ選択画面を表示")
        if let delegate = delegate {
            delegate.categoryViewButtonDelegate()
        }
    }
}
