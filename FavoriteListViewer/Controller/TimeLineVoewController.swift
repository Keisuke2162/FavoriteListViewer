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
    var dataSource: TweetDataSource!
    var isTwitterAPI: Bool = false
    let categoryView = CategoryViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        //UI設計
        settingUI()
        
        
        dataSource = TweetDataSource()
        dataSource.delegate = self          //タイムライン取得終了通知を受け取る
        
        //Twitterボタンから来た場合はTwitterAPIとの通信を行う
        if isTwitterAPI {
            
            dataSource.accountAuth()       //TwitterAPI+Realmからのデータ
        } else {
            dataSource.dataLoad()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWllappear")
        //dataSource.dataLoad()   //Realmからデータ取得

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
        return dataSource.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TweetViewCell
        cell.delegate = self
        
        let tweet = dataSource.showData(at: indexPath.row)
        cell.tweet = tweet
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 750
    }
}

extension TimelineViewController: FinishToGetTimelineDelegate {
    
    func reloadTimeline() {
        tableView.reloadData()
    }
}

extension TimelineViewController: CellSelectedDelegate {
    func categoryViewButtonDelegate() {
        
        let vc = CategoryViewController()
        present(vc, animated: true, completion: nil)
    }
}
