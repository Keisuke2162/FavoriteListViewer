//
//  HomeViewController.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    var scrollView: UIScrollView!   //カテゴリボタン配置するView
    var categoryList: [category]!   //カテゴリ一覧
    
    
    //カテゴリ追加画面に遷移
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        getCategory()   //
        settingView()   //

        // Do any additional setup after loading the view.
    }
    
    //データ取得
    func getCategory() {
        //カテゴリ一覧を取得
        categoryList = CategoryData().getCategory()
        print("カテゴリ数 -> \(categoryList.count)")
    }
    
    //UI配置
    //ホーム＋各カテゴリのホームボタンを作成
    func settingView() {
        //ヘッダー作成(ユーザー名とアイコンを載せる)
        let headerView = UILabel()  //テスト用にUILabel()。実際はUIView()で中身に情報を載せていく
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        headerView.backgroundColor = .cyan
        headerView.textAlignment = .center
        headerView.text = "User Data"
        view.addSubview(headerView)
        
        //カテゴリボタン設置用ScrollViewを設置
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: headerView.frame.height, width: self.view.frame.width, height: self.view.frame.height - 170)
        //scrollView.contentSize    //カテゴリ数から高さを算出
        view.addSubview(scrollView)
        
        let buttonHeight: CGFloat = self.scrollView.frame.height / 3 - 50
        let buttonWidth: CGFloat = self.scrollView.frame.width - 80
        
        //ホームタイムライン用ボタン作成
        let homeTimeLineButton = UIButton()
        homeTimeLineButton.frame.size = CGSize(width: buttonWidth, height:buttonHeight)
        homeTimeLineButton.center = CGPoint(x: self.view.frame.width / 2, y: self.scrollView.frame.height / 6)
        homeTimeLineButton.layer.cornerRadius = 10.0
        homeTimeLineButton.backgroundColor = UIColor(colorCode: "1DA1F2")
        homeTimeLineButton.layer.shadowOpacity = 0.3
        homeTimeLineButton.layer.shadowRadius = 10.0
        homeTimeLineButton.layer.shadowColor = UIColor.black.cgColor
        homeTimeLineButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        homeTimeLineButton.imageView?.contentMode = .scaleAspectFit
        homeTimeLineButton.imageEdgeInsets = UIEdgeInsets(top: buttonHeight * 0.2, left: 0, bottom: buttonHeight * 0.4, right: 0)
        homeTimeLineButton.setImage(UIImage(named: "twitter"), for: .normal)
        let titleLabel = UILabel()
        titleLabel.frame.size = CGSize(width: buttonWidth, height: buttonHeight * 0.2)
        titleLabel.center = CGPoint(x: homeTimeLineButton.frame.width / 2, y: homeTimeLineButton.frame.height * 0.8)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        titleLabel.text = "Twitter Likes List"
        homeTimeLineButton.addSubview(titleLabel)
        scrollView.addSubview(homeTimeLineButton)
        
        //各カテゴリボタン作成
        for i in 0 ..< categoryList.count {
            
        }
        
        //カテゴリ追加ボタン作成
        let addCategoryButton = UIButton()
        addCategoryButton.frame = CGRect(x: 0, y: self.view.frame.height - 70, width: self.view.frame.width, height: 70)
        addCategoryButton.backgroundColor = .black
        addCategoryButton.setTitle("+ Add Category", for: .normal)
        addCategoryButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        view.addSubview(addCategoryButton)
        
    }
    
    @objc func addCategory() {
        let vc = AddCategoryViewController()
        present(vc, animated: true, completion: nil)
        
    }
}




