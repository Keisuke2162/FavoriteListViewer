//
//  GetLikesList.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift

class TimeLineDataSource: NSObject {
    
    var accessToken = ""
    var accessSecret = ""
    let comsumerKey = "2H2A7Ej1g4WBimFP4V888reYG"
    let comsumerSecret = "wHfBRX9bXBtqBmDKxwzfCHcLVFkegX5Ry0mnt5GSsvGEqA5Xts"
    
    
    //認証トークン、シークレットキーを初期化
    init(token: String, secret: String) {
        accessToken = token
        accessSecret = secret
    }
    
    //いいね欄を取得
    func getTimeLine() -> [Favorite] {
        
        var favoriteList: [Favorite] = []
        
        guard let url = URL(string: "https://api.twitter.com/1.1/account/settings.json") else {
            print("Get setting error")
            return favoriteList
        }
        guard let favUrl = URL(string: "https://api.twitter.com/1.1/favorites/list.json") else {
            print("Get favorite error")
            return favoriteList
        }
        
        let client = OAuthSwiftClient(
            consumerKey: comsumerKey,
            consumerSecret: comsumerSecret,
            oauthToken: accessToken,
            oauthTokenSecret: accessSecret,
            version: .oauth1
        )
        
        //ユーザーの設定を取得
        client.get(url, completionHandler: { result in
            switch result {
                case .success(let response):
                    print(response.data.count)
                
                    guard let setting = try? JSONDecoder().decode(TwitterSetting.self, from: response.data) else {
                        print("Twitterの設定データ変換エラー")
                        return
                    }
                    
                    //ユーザーの設定が正常に取得できたらユーザーのいいね欄を取得
                    let paramater: OAuthSwift.ConfigParameters = ["screen_name":setting.screenName, "count":"5"]
                            
                    client.get(favUrl, parameters: paramater, headers: nil, completionHandler: { favResult in
                        switch favResult {
                            case .success(let favResponse):
                                print("タイムライン取得成功")
                                print(favResponse.data)
                                //

                                let jsonData = try? JSONSerialization.jsonObject(with: favResponse.data, options: JSONSerialization.ReadingOptions.allowFragments)
                                print(jsonData!)
                                    
                                //いいね欄のツイート情報を取得
                                guard let tweetData = try? JSONDecoder().decode([Favorite].self, from: favResponse.data) else {
                                    print("タイムラインのデコードエラー")
                                    return
                                }
                                favoriteList = tweetData

                                
                            case .failure:
                                print("タイムラインの取得エラー")
                                break
                        }
                    })
                case .failure:
                    print("Twitterの設定データの変換エラー")
                    break
            }
        })
        return favoriteList
    }
    
    //タイムライン情報をRealmの型に変換する
    func convertTimeline(favorites: [Favorite]) -> [TweetObject] {
        var tweetObjects: [TweetObject] = []
        
        for favorite in favorites {
            let object: TweetObject = TweetObject()
            
            object.userIcon = favorite.user.profile_image_url_https
            object.userName = favorite.user.screen_name
            object.userID = favorite.user.id_str
            object.tweetID = favorite.id_str
            object.content = favorite.text
            //画像等の情報があれば格納
            if let medias = favorite.extended_entities {
                for media in medias.media {
                    let mediaObject = Extended_Entities()
                    mediaObject.type = media.type
                    mediaObject.imageURL = media.media_url_https
                    object.picImage.append(mediaObject)
                }
            }
            tweetObjects.append(object)
        }
        return tweetObjects
    }
    
}
