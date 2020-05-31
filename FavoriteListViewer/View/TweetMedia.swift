//
//  TweetMedia.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/28.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class TweetMediaView: NSObject {
    
    private var type: String!
    private var urls: [String]!
    
    init(Urls: [String], typeStr: String) {
        type = typeStr
        urls = Urls
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
