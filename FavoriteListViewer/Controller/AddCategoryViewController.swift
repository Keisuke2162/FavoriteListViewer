//
//  AddCategoryViewController.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

protocol CreateCategoryButtonDelegate {
    func saveCategoryList(title: String, color: String, icon: String)
}

class AddCategoryViewController: UIViewController {
    
    //let colorList: [String] = ["008dd6","e13816","eea800","9f0082","dea014","ad6ba2","eec800","1d121f","a47a46","004f7a"]
    let colorList: [String] = ["005481","19a591","b2d6b5","afc0e2","a4c8c2","9b6cab","5a6d8f","37a0c8","1b4a8b","a0b0d8"]
    let iconList: [String] = ["twitter","bird","fenix","chiken","crane","dove","duck","hummingbird","penguin","swan"]
    var colorCheckLabel: UILabel!   //カラーのチェック用リング
    var iconCheckLabel: UILabel!    //アイコンのチェック用リング
    var titleText: String = ""      //入力したタイトル
    var colorCode: String = ""      //選択した色
    var iconCode: String = ""       //選択したアイコン
    var titleField: UITextField!    //タイトル入力エリア
    var addCategoryDelegate: CreateCategoryButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        settingUI()
    }
    
    func settingUI() {
        //Title Area
        let titleArea = UIView()
        titleArea.frame = CGRect(x: 0,
                                 y: 30,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height / 4)
        view.addSubview(titleArea)
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 10,
                                  y: 0,
                                  width: view.frame.width,
                                  height: titleArea.frame.height / 4)
        titleLabel.textColor = UIColor.dynamicColor(light: .black, dark: .white)
        titleLabel.text = "Title"
        titleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        titleArea.addSubview(titleLabel)
        
        titleField = UITextField()
        titleField.frame.size = CGSize(width: titleArea.frame.width / 1.5, height: titleArea.frame.height / 4)
        titleField.center = CGPoint(x: titleArea.frame.width / 2, y: titleArea.frame.height / 2)
        titleField.textColor = UIColor.dynamicColor(light: .black, dark: .white)
        titleField.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        titleField.addBorderBottom(height: 1.0, color: .white)
        titleArea.addSubview(titleField)
        
        
        //Color Area
        let colorArea = UIView()
        colorArea.frame = CGRect(x: 0,
                                 y: titleArea.frame.maxY,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height / 4)
        view.addSubview(colorArea)
        
        let colorLabel = UILabel()
        colorLabel.frame = CGRect(x: 10, y: 0, width: view.frame.width, height: colorArea.frame.height / 4)
        colorLabel.textColor = UIColor.dynamicColor(light: .black, dark: .white)
        colorLabel.text = "Color"
        colorLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        colorArea.addSubview(colorLabel)
        
        colorCheckLabel = UILabel()
        colorCheckLabel.frame.size = CGSize(width: colorArea.frame.height / 4 + 10, height: colorArea.frame.height / 4 + 10)
        colorCheckLabel.layer.cornerRadius = colorArea.frame.height / 8 + 5
        colorCheckLabel.layer.borderColor = UIColor.clear.cgColor
        colorCheckLabel.layer.borderWidth = 2.0
        colorArea.addSubview(colorCheckLabel)
        
        for i in 0 ..< colorList.count {
            let colorButton = UIButton()
            colorButton.frame = CGRect(x: colorArea.frame.width / 6 * CGFloat(i % 5 + 1),
                                       y: colorArea.frame.height / 3 * CGFloat(i / 5 + 1),
                                       width: colorArea.frame.height / 4,
                                       height: colorArea.frame.height / 4)
            colorButton.layer.cornerRadius = colorArea.frame.height / 8
            colorButton.tag = i
            colorButton.backgroundColor = UIColor(colorCode: colorList[i])
            colorButton.addTarget(self, action: #selector(TappedColorButton), for: .touchUpInside)
            colorArea.addSubview(colorButton)
        }
        
        
        //IconArea
        let iconArea = UIView()
        iconArea.frame = CGRect(x: 0, y: colorArea.frame.maxY, width: self.view.frame.width, height: self.view.frame.height / 4)
        view.addSubview(iconArea)
        
        let iconLabel = UILabel()
        iconLabel.frame = CGRect(x: 10, y: 0, width: view.frame.width, height: iconArea.frame.height / 4)
        iconLabel.textColor = UIColor.dynamicColor(light: .black, dark: .white)
        iconLabel.text = "Icon"
        iconLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        iconArea.addSubview(iconLabel)
        
        iconCheckLabel = UILabel()
        iconCheckLabel.frame.size = CGSize(width: iconArea.frame.height / 4 + 10, height: iconArea.frame.height / 4 + 10)
        iconCheckLabel.layer.cornerRadius = iconArea.frame.height / 8 + 5
        iconCheckLabel.layer.borderColor = UIColor.clear.cgColor
        iconCheckLabel.layer.borderWidth = 2.0
        iconArea.addSubview(iconCheckLabel)
        
        for j in 0 ..< iconList.count {
            let iconButton = UIButton()
            iconButton.frame = CGRect(x: iconArea.frame.width / 6 * CGFloat(j % 5 + 1),
                                       y: iconArea.frame.height / 3 * CGFloat(j / 5 + 1),
                                       width: iconArea.frame.height / 4,
                                       height: iconArea.frame.height / 4)
            iconButton.layer.cornerRadius = iconArea.frame.height / 8
            iconButton.tag = j
            iconButton.backgroundColor = UIColor(colorCode: colorList[j])
            iconButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            iconButton.setImage(UIImage(named: iconList[j]), for: .normal)
            iconButton.addTarget(self, action: #selector(TappedIconButton), for: .touchUpInside)
            iconArea.addSubview(iconButton)
        }
        
        //DecisionButton
        let decisionButton = UIButton()
        decisionButton.frame.size = CGSize(width: self.view.frame.height / 10, height: self.view.frame.height / 10)
        decisionButton.center = CGPoint(x: self.view.frame.width / 2, y: iconArea.frame.maxY + self.view.frame.height / 15)
        decisionButton.backgroundColor = UIColor.dynamicColor(light: .black, dark: .white)
        decisionButton.layer.cornerRadius = self.view.frame.height / 20
        decisionButton.addTarget(self, action: #selector(TappedDecisionButton), for: .touchUpInside)
        view.addSubview(decisionButton)
    }
    
    @objc func TappedIconButton(_ sender: UIButton) {
        iconCode = iconList[sender.tag]
        iconCheckLabel.layer.borderColor = UIColor(colorCode: colorList[sender.tag]).cgColor
        iconCheckLabel.center = sender.center
    }
    
    @objc func TappedColorButton(_ sender: UIButton) {
        colorCode = colorList[sender.tag]
        colorCheckLabel.layer.borderColor = UIColor(colorCode: colorList[sender.tag]).cgColor
        colorCheckLabel.center = sender.center
    }
    
    @objc func TappedDecisionButton() {
        if let title = titleField.text {
            titleText = title
        }
        
        if titleText == "" {
            //タイトルが入力されていない
        } else if colorCode == "" {
            //色が選択されていない
        } else if iconCode == "" {
            //アイコンが選択されていない
        } else {
            if let delegate = addCategoryDelegate {
                delegate.saveCategoryList(title: titleText, color: colorCode, icon: iconCode)
            }
            dismiss(animated: true, completion: nil)
        }
    }
}

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
