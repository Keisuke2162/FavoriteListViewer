//
//  ShowTweetModel.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/31.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class Tweet: NSObject {
    
    let icon: UIImage               //
    let name: String                //
    let id: String                  //
    let context: String             //
    var images: [UIImage] = []      //
    var movies: [URL] = []          //
    
    init(icon: String, name: String, id: String, context: String?, images: [String]?, movies: [String]?) {
        self.icon = UIImage(url: icon)
        self.name = name
        self.id = id
        if let context = context {
            self.context = context
        } else {
            self.context = ""
        }
        if let images = images {
            for image in images {
                self.images.append(UIImage(url: image))
            }
        }
        if let movies = movies {
            for movie in movies {
                self.movies.append(URL(fileURLWithPath: movie))
            }
        }
    }
}

class TweetDataSource: NSObject {
    
    private var tweets = [Tweet]()          //Cellに表示するデータ
    private var apiContents = [Tweet]()
    let realm = ManagementTweetObject()     //Realmデータ管理クラス
    
    //
    func dataLoad() {
        //Realmからデータ取得
        let realmObjects = realm.getTweetObject()
        
        //Realmからのデータで1件ずつtweetを作成
        for object in realmObjects {
            var images: [String] = []
            var movies: [String] = []
            
            for media in object.picImage {
                if media.type == "photo" {
                    images.append(media.imageURL)
                } else if media.type == "video" {
                    movies.append(media.imageURL)
                }
            }
            let tweet = Tweet(icon: object.userIcon, name: object.userName,
                              id: object.userID, context: object.content, images: images, movies: movies)
            tweets.append(tweet)
        }
    }
    
    //TwitterAPIからデータ取得
    func dataGet() {
        
        //Realmからデータを取得
        let realmObjects = realm.getTweetObject()
        
        //UserDefaultsから認証データ取得
        let auth = TwitterAuth()
        var keyData = auth.getKeys()
        
        //未認証だったら//Twitter認証して再度UserDefaultsから取得
        if keyData.0 == "key" || keyData.1 == "secret" {
            //Twitter認証して再度UserDefaultsから取得
            auth.authTwitter()
            keyData = auth.getKeys()
        }
        
        //LikesList取得
        let timeline = TimeLineDataSource(token: keyData.0, secret: keyData.1)
        timeline.getTimeLine(success: { favorites in
            //[TweetObject]に変換
            var favoriteObjects = timeline.convertTimeline(favorites: favorites)
            
            //新規追加データのみピックアップ
            favoriteObjects = self.realm.newTimeline(realmObjects: realmObjects, apiObjects: favoriteObjects)
            
            //新規データとRealmから取得したデータをマージ
            favoriteObjects = favoriteObjects + realmObjects
            
            //データをRealmに保存する
            self.realm.saveTweetObject(saveObjects: favoriteObjects)
            
            //マージした配列から1件ずつtweetを作成
            for object in favoriteObjects {
                var images: [String] = []
                var movies: [String] = []
                
                for media in object.picImage {
                    if media.type == "photo" {
                        images.append(media.imageURL)
                    } else if media.type == "video" {
                        movies.append(media.imageURL)
                    }
                }
                let tweet = Tweet(icon: object.userIcon, name: object.userName,
                                  id: object.userID, context: object.content, images: images, movies: movies)
                self.tweets.append(tweet)
            }
            
        }, failure: { (error) in
            //タイムライン取得失敗
            print("Error")
        })
    }
    
    //表示する数を返す
    func count() -> Int {
        return tweets.count
    }
    
    //表示内容を返す
    func showData(at index: Int) -> Tweet? {
        if tweets.count > index {
            return tweets[index]
        }
        return nil
    }
}
