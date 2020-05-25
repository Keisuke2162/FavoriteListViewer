//
//  Authentication.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import OAuthSwift
import Firebase

class TwitterAuth {
    
    var provider: OAuthProvider = OAuthProvider(providerID: "twitter.com")  //Twitter認証
    let twitterKeyValue = UserDefaults.standard //UserDefaults
    var token: String = ""      //トークン
    var secret: String = ""     //シークレットキー
    
    //UserDefaultsから認証キー取得
    func getKeys() {
        
        twitterKeyValue.register(defaults: ["tokenKey": "key"])
        twitterKeyValue.register(defaults: ["secretKey": "secret"])
        
        token = twitterKeyValue.object(forKey: "tokenKey") as! String
        secret = twitterKeyValue.object(forKey: "secretKey") as! String
    }
    //Twitter認証処理
    func authTwitter() {
        print("start Authentication")
        provider.getCredentialWith(nil, completion: { credential, error in
            if error != nil {
                print("Error Handring")
            }
            
            if credential != nil {
                Auth.auth().signIn(with: credential!, completion: { authResult, error in
                    if error != nil {
                        print("SignIn Error")
                    }
                    
                    //認証情報が取得できたらUserDefaultsに保存する
                    if let credential = authResult?.credential as? OAuthCredential,
                        let accessToken = credential.accessToken,
                        let accessSecret = credential.secret {
                        
                        print(accessToken)
                        
                        self.twitterKeyValue.set(accessToken, forKey: "tokenKey")
                        self.twitterKeyValue.set(accessSecret, forKey: "secretKey")
                    } else {
                        print("not TOken")
                    }
                })
            }
        })
    }
}

