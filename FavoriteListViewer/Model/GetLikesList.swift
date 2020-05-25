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
    func getTimeLine() {
        
        guard let url = URL(string: "https://api.twitter.com/1.1/account/settings.json") else {
            print("Get setting error")
            return
        }
        guard let favUrl = URL(string: "https://api.twitter.com/1.1/favorites/list.json") else {
            print("Get favorite error")
            return
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
                        print("SettingData_Decode Error")
                        return
                    }
                    
                    //ユーザーの設定が正常に取得できたらユーザーのいいね欄を取得
                    let paramater: OAuthSwift.ConfigParameters = ["screen_name":setting.screenName, "count":"200"]
                            
                    client.get(favUrl, parameters: paramater, headers: nil, completionHandler: { favResult in
                        switch favResult {
                            case .success(let favResponse):
                                print("fav_success")
                                //
                                DispatchQueue.main.async {
                                    //いいね欄のツイート情報を取得
                                    guard (try? JSONDecoder().decode([Favorite].self, from: favResponse.data)) != nil else {
                                        print("FavoriteList_Decode Error")
                                        return
                                    }
                                }
                                
                            case .failure:
                                print("fav_failure")
                                break
                        }
                    })
                case .failure:
                    break
            }
        })
    }
}
