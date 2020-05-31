//
//  RealmObject.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/28.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import RealmSwift

class TweetObject: Object {
    //ツイート内容
    @objc dynamic var userIcon: String = ""         //ユーザアイコンのURL
    @objc dynamic var userName: String = ""         //ユーザ名
    @objc dynamic var userID: String = ""           //ユーザID
    @objc dynamic var content: String = ""          //ツイート内容
    @objc dynamic var tweetID: String = ""          //ツイートID
    let picImage = List<Extended_Entities>()        //画像orGIFor動画一覧
    
    //@objc dynamic var isCategorise: Bool = false    //カテゴライズ済みかどうか
    
    @objc dynamic var category: String?             //カテゴリ名
}

class Extended_Entities: Object {
    @objc dynamic var imageURL: String = ""
    @objc dynamic var type: String = ""
}

class ManagementTweetObject: NSObject {
    
    let realm = try! Realm()
    //var realmObjects: [TweetObject] = []
    
    //Realmから配列を取得
    func getTweetObject() -> [TweetObject]{
        let realmObjects = Array(realm.objects(TweetObject.self))
        return realmObjects
    }
    
    //Realmに配列を保存
    func saveTweetObject(saveObjects: [TweetObject]) {
        //1レコードずつ保存していく
        for object in saveObjects {
            try! realm.write {
                realm.add(object)
            }
        }
    }
    
    //TwitterAPIから取得した内容の中からRealmに保存されていないものをピックアップ
    func newTimeline(realmObjects: [TweetObject], apiObjects: [TweetObject]) -> [TweetObject] {
        var newObjects: [TweetObject] = []      //新規追加となる要素一覧
        //
        for apiObject in apiObjects {
            var isSameId: Bool = false
            for realmObject in realmObjects {
                if apiObject.tweetID == realmObject.tweetID {
                    isSameId = true
                    break
                }
            }
            if (isSameId) {
                print("同IDのツイートあり")
            } else {
                newObjects.append(apiObject)    //新規追加要素にタイムライン情報を追加
            }
        }
        return newObjects
    }
    
    //タイムラインに表示できる形に変換
    func conversionShowTimeline() {
        
    }
}
