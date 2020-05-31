//
//  CategoryData.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation

class CategoryData: NSObject {
    
    let userDefauls = UserDefaults.standard
    
    //[Data]形式のデータをUserDefaultsから取得し、デコードして[category]の形でreturn
    func getCategory() -> [category] {
        guard let encodeData = userDefauls.array(forKey: "categoryValue") as? [Data] else {
            return []
        }
        //~.map -> 配列全体に処理を行う
        let data = encodeData.map { try! JSONDecoder().decode(category.self, from: $0)}
        return data
    }

    
    //[category]形式のデータを[Data]にエンコードしてUserDefaultsに保存
    func saveCategory(_ saveData: [category]) {
        let data = saveData.map { try! JSONEncoder().encode($0)}
        userDefauls.set(data, forKey: "categoryValue")
    }
}

//カテゴリデータモデル
struct category: Codable {
    var title: String   //カテゴリ名
    var color: String   //カテゴリカラー
    var image: String   //カテゴリアイコン
    
    init(setTitle: String, setColor: String, setImage: String) {
        self.title = setTitle
        self.color = setColor
        self.image = setImage
    }
}
