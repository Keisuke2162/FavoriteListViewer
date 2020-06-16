//
//  ShowTweetModel.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/31.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

protocol FinishToGetTimelineDelegate {
    func reloadTimeline()
}

class Tweet: NSObject {
    
    let icon: UIImage               //アイコン画像
    let name: String                //ユーザ名
    let id: String                  //ユーザID
    let context: String             //ツイート内容
    var images: [UIImage] = []      //画像一覧
    var movies: [URL] = []          //動画URL一覧
    var linkUrls: [String] = []        //リンクURL一覧
    
    init(icon: String, name: String, id: String, context: String?, images: [String]?, movies: [String]?, links: [String]?) {
        self.icon = UIImage(url: icon)      //ユーザーアイコン
        self.name = name                    //ユーザ名
        self.id = id                        //ユーザーID
        if let context = context {          //ツイート内容
            self.context = context
        } else {
            self.context = ""
        }
        
        if let images = images {            //ツイートに含まれる画像URL
            for image in images {
                self.images.append(UIImage(url: image))
            }
        }
        
        if let movies = movies {            //ツイートに含まれる動画URL
            for movie in movies {
                self.movies.append(URL(fileURLWithPath: movie))
            }
        }
        
        if let links = links {              //ツイートに含まれるリンクURL
            for link in links {
                self.linkUrls.append(link)
            }
        }
        
    }
}

class TweetDataSource: NSObject {
    
    let makeLinks = Link()                          //ツイート内容からリンクを抽出
    
    private var tweets = [Tweet]()                  //Cellに表示するデータ
    private var apiContents = [Tweet]()
    let realm = ManagementTweetObject()             //Realmデータ管理クラス
    
    var delegate: FinishToGetTimelineDelegate?      //APIでのタイムライン取得終了通知ß
    
    //
    func dataLoad() {
        //Realmからデータ取得
        let realmObjects = realm.getTweetObject()
        
        //Realmからのデータで1件ずつtweetを作成
        for object in realmObjects {
            var imageArray: [String] = []
            var movieArray: [String] = []
            var linkArray: [String] = []
            
            //画像URLから画像を作成
            for media in object.picImage {
                if media.type == "photo" {
                    imageArray.append(media.imageURL)
                } else if media.type == "video" {
                    movieArray.append(media.imageURL)
                }
            }
            
            for link in object.links {
                linkArray.append(link.link)
            }
            let tweet = Tweet(icon: object.userIcon, name: object.userName,
                              id: object.userID, context: object.content, images: imageArray, movies: movieArray, links: linkArray)
            tweets.append(tweet)
        }
        
        if let delegate = self.delegate {
            delegate.reloadTimeline()
        }
    }
    
    //TwitterAPIからデータ取得してRealmのデータと結合
    func accountAuth() {
        
        //認証情報クラス
        let auth = TwitterAuth()
        auth.delegate = self
        
        auth.getKeys()
    }

    
    //表示する数を返す
    func count() -> Int {
        print("Tweetの数は -> \(tweets.count)")
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

extension TweetDataSource: FinishAuthenticationDelegate {
    
    func GETLikesListData(token: String, secret: String) {
        
        //Realmからデータを取得
        let realmObjects = realm.getTweetObject()
        
        //いいね欄の一覧を取得
        print("タイムラインの取得を開始します　token -> \(token) secret -> \(secret)")
        let timeline = TimeLineDataSource(token: token, secret: secret)
        timeline.getTimeLine(success: { favorites in
            
            //ツイートに含まれるリンクを表示（テスト用）
            for i in favorites {
                print("Link Search")
                if let urls = i.entities.urls {
                    for j in urls {
                        print(j.expanded_url)
                    }
                }
            }
                
            //[TweetObject]に変換
            var favoriteObjects = timeline.convertTimeline(favorites: favorites)
                
            //RealmのデータとAPIのデータを比較、新規のもののみピックアップ
            favoriteObjects = self.realm.newTimeline(realmObjects: realmObjects, apiObjects: favoriteObjects)
                
            //TwitterAPIにて取得したいいね欄とRealmから取得したデータをマージ
            favoriteObjects = favoriteObjects + realmObjects
                
            //データをRealmに保存する
            self.realm.saveTweetObject(saveObjects: favoriteObjects)
                
            //マージした配列から1件ずつtweetを作成
            for object in favoriteObjects {
                var imageArray: [String] = []           //画像一覧
                var movieArray: [String] = []           //動画一覧
                var linkArray: [String] = []
                
                //メディアを仕分け（画像と動画）
                for media in object.picImage {
                    if media.type == "photo" {
                        imageArray.append(media.imageURL)
                    } else if media.type == "video" {
                        movieArray.append(media.imageURL)
                    }
                }
                
                //ツイートに含まれるリンクをまとめる
                for link in object.links {
                    linkArray.append(link.link)
                }
                
                let tweet = Tweet(icon: object.userIcon, name: object.userName,
                                  id: object.userID, context: object.content, images: imageArray, movies: movieArray, links: linkArray)
                self.tweets.append(tweet)
            }
            
            if let delegate = self.delegate {
                delegate.reloadTimeline()
            }
                
        }, failure: { (error) in
            //タイムライン取得失敗
            print("Error")
        })
    }
}


class Link: NSObject {
    func pickupLink(str: String) -> [URL] {
        let dector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let links = dector.matches(in: str, range: NSMakeRange(0, str.count))
        return links.compactMap { $0.url }
    }
}
