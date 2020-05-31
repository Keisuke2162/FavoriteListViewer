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
    var favoriteObjects: [Favorite] = []        //twitterAPIから取得したデータを入れる
    var realmTweetObjects: [TweetObject] = []   //Realmに変換したデータを入れる
    var showTimeline: [TweetObject] = []        //表示用オブジェクト（いらない方法有りそう）
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        //UI設計
        settingUI()
        
    }
    
    func twitterLikeslistView() {
        //Realmからタイムラインのデータを取得
        let realm = ManagementTweetObject()
        let realmObjects = realm.getTweetObject()
        print("Realmから取得したデータ -> \(realmObjects.count)")
        
        let timelineData = TimeLineDataSource(token: token, secret: secret)
        
        timelineData.getTimeLine(success: { favorits in
            
            self.favoriteObjects = favorits
            print("TwitterAPiから取得したデータ -> \(favorits.count)")
            //APIから取得したデータをRealmに保存できる形に変換する
            self.realmTweetObjects = timelineData.convertTimeline(favorites: self.favoriteObjects)
            print("Realm型に変換したデータ -> \(self.realmTweetObjects.count)")
            //保存済みデータと比較して未保存データに絞る
            self.realmTweetObjects = realm.newTimeline(realmObjects: realmObjects, apiObjects: self.realmTweetObjects)
            print("新規ツイートデータ -> \(self.realmTweetObjects.count)")
            //新規データをRealmに保存する
            realm.saveTweetObject(saveObjects: self.realmTweetObjects)
            //表示用配列に新規＋既存データを格納
            self.showTimeline = self.realmTweetObjects + realmObjects
            print("表示するデータ数 -> \(self.showTimeline.count)")
            
            self.tableView.reloadData()
            
        }, failure: { (error) in
            print("ERROR!")
        })
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
        print("表示するセルの数 -> \(showTimeline.count)")
        view.addSubview(tableView)
        
    }
    
    @objc func TappedReturnButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showTimeline.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TweetViewCell
        var media: String?
        if showTimeline[indexPath.row].picImage.count != 0 {
            media = showTimeline[indexPath.row].picImage[0].imageURL
        }
        cell.settingCellContent(name: showTimeline[indexPath.row].userName,
                                id: showTimeline[indexPath.row].userID,
                                content: showTimeline[indexPath.row].content,
                                media: media)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width + 150
    }
    
    
}
