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
    
    var scrollView: UIScrollView!       //カテゴリボタン配置するView
    var categoryList: [category]!       //カテゴリ一覧
    let categoryDB = CategoryData()     //カテゴリ一覧取得のためのuserDefaults
    var buttonHeight: CGFloat = 0.0     //カテゴリボタンの高さ
    var buttonWidth: CGFloat = 0.0      //カテゴリボタンの幅
    
    
    //カテゴリ追加画面に遷移
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        getCategory()   //
        settingView()   //
        
        //let data = TweetDataSource()
        //data.dataGet()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //getCategory()
        //settingView()
    }
    
    //データ取得
    func getCategory() {
        //カテゴリ一覧を取得
        categoryList = categoryDB.getCategory()
        print("カテゴリ数 -> \(categoryList.count)")
    }
    
    //データ保存
    
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
        
        buttonHeight = self.scrollView.frame.height / 3 - 50
        buttonWidth = self.scrollView.frame.width - 80
        
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
        homeTimeLineButton.tag = 9999
        homeTimeLineButton.addTarget(self, action: #selector(TappedCategoryButton), for: .touchUpInside)
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
            
            let yPosWeight: Int = i * 2 + 3
            
            //scrollViewの最下部に新カテゴリのボタンを追加してcontentSizeを調整
            let categoryButton = UIButton()
            categoryButton.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
            categoryButton.center = CGPoint(x: self.view.frame.width / 2, y: self.scrollView.frame.height / 6 * CGFloat(yPosWeight))
            categoryButton.layer.cornerRadius = 10.0
            categoryButton.backgroundColor = UIColor(colorCode: categoryList[i].color)
            categoryButton.layer.shadowOpacity = 0.3
            categoryButton.layer.shadowRadius = 10.0
            categoryButton.layer.shadowColor = UIColor.black.cgColor
            categoryButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            categoryButton.imageView?.contentMode = .scaleAspectFit
            categoryButton.imageEdgeInsets = UIEdgeInsets(top: buttonHeight * 0.2, left: 0, bottom: buttonHeight * 0.4, right: 0)
            categoryButton.setImage(UIImage(named: categoryList[i].image), for: .normal)
            categoryButton.tag = i
            categoryButton.addTarget(self, action: #selector(TappedCategoryButton), for: .touchUpInside)
            let categoryLabel = UILabel()
            categoryLabel.frame.size = CGSize(width: buttonWidth, height: buttonHeight * 0.2)
            categoryLabel.center = CGPoint(x: categoryButton.frame.width / 2, y: categoryButton.frame.height * 0.8)
            categoryLabel.textAlignment = .center
            categoryLabel.textColor = .white
            categoryLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
            categoryLabel.text = categoryList[i].title
            categoryButton.addSubview(categoryLabel)
            scrollView.addSubview(categoryButton)
            
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height / 6 * CGFloat(yPosWeight + 5))
        }
        
        //カテゴリ追加ボタン作成
        let addCategoryButton = UIButton()
        addCategoryButton.frame = CGRect(x: 0, y: self.view.frame.height - 70, width: self.view.frame.width, height: 70)
        addCategoryButton.backgroundColor = .black
        addCategoryButton.setTitle("+ Add Category", for: .normal)
        addCategoryButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        view.addSubview(addCategoryButton)
        
    }
    
    @objc func TappedCategoryButton(_ sender: UIButton) {
        let vc = TimelineViewController()
        
        //LikesList（オリジナルのタイムライン取得）の場合はTwitter認証する
        if sender.tag == 9999 {
            vc.backgroundColor = "1DA1F2"
            vc.iconImage = "twitter"
            vc.isTwitterAPI = true
        } else {
            vc.backgroundColor = categoryList[sender.tag].color
            vc.iconImage = categoryList[sender.tag].image
            vc.isTwitterAPI = false
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func addCategory() {
        let vc = AddCategoryViewController()
        vc.addCategoryDelegate = self
        present(vc, animated: true, completion: nil)
    }
}


extension HomeViewController: CreateCategoryButtonDelegate {
    
    func saveCategoryList(title: String, color: String, icon: String) {
        //
        let categoryData = category.init(setTitle: title, setColor: color, setImage: icon)
        categoryList.append(categoryData)
        categoryDB.saveCategory(categoryList)
        
        let yPosWeight: Int = categoryList.count * 2 + 1
        //let contentSizeWeight: Int = categoryList.count + 1
        
        //scrollViewの最下部に新カテゴリのボタンを追加してcontentSizeを調整
        let newCategoryButton = UIButton()
        newCategoryButton.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        newCategoryButton.center = CGPoint(x: self.view.frame.width / 2, y: self.scrollView.frame.height / 6 * CGFloat(yPosWeight))
        newCategoryButton.layer.cornerRadius = 10.0
        newCategoryButton.backgroundColor = UIColor(colorCode: categoryData.color)
        newCategoryButton.layer.shadowOpacity = 0.3
        newCategoryButton.layer.shadowRadius = 10.0
        newCategoryButton.layer.shadowColor = UIColor.black.cgColor
        newCategoryButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        newCategoryButton.imageView?.contentMode = .scaleAspectFit
        newCategoryButton.imageEdgeInsets = UIEdgeInsets(top: buttonHeight * 0.2, left: 0, bottom: buttonHeight * 0.4, right: 0)
        newCategoryButton.setImage(UIImage(named: categoryData.image), for: .normal)
        newCategoryButton.tag = categoryList.count - 1
        newCategoryButton.addTarget(self, action: #selector(TappedCategoryButton), for: .touchUpInside)
        let titleLabel = UILabel()
        titleLabel.frame.size = CGSize(width: buttonWidth, height: buttonHeight * 0.2)
        titleLabel.center = CGPoint(x: newCategoryButton.frame.width / 2, y: newCategoryButton.frame.height * 0.8)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        titleLabel.text = categoryData.title
        newCategoryButton.addSubview(titleLabel)
        scrollView.addSubview(newCategoryButton)
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height / 6 * CGFloat(yPosWeight + 5))
    }
}
