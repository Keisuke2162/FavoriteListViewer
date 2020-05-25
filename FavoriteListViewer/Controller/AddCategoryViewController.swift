//
//  AddCategoryViewController.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class AddCategoryViewController: UIViewController {
    
    let colorList: [String] = ["008dd6","e13816","eea800","9f0082","dea014","ad6ba2","eec800","1d121f","a47a46","004f7a"]
    let iconList: [String] = ["twitter","bird","fenix","chiken","crane","dove","duck","hummingbird","penguin","swan"]
    
    var colorCheckLabel: UILabel!   //カラーのチェック用リング
    var iconCheckLabel: UILabel!    //アイコンのチェック用リング
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
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
        titleLabel.text = "Title"
        titleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        titleArea.addSubview(titleLabel)
        
        let titleField = UITextField()
        titleField.frame.size = CGSize(width: titleArea.frame.width / 1.5, height: titleArea.frame.height / 4)
        titleField.center = CGPoint(x: titleArea.frame.width / 2, y: titleArea.frame.height / 2)
        titleField.layer.borderColor = UIColor.black.cgColor
        titleField.layer.borderWidth = 1.0
        titleField.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
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
        decisionButton.backgroundColor = .black
        decisionButton.layer.cornerRadius = self.view.frame.height / 20
        decisionButton.addTarget(self, action: #selector(TappedDecisionButton), for: .touchUpInside)
        view.addSubview(decisionButton)
    }
    
    @objc func TappedDecisionButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func TappedIconButton(_ sender: UIButton) {
        iconCheckLabel.layer.borderColor = UIColor(colorCode: colorList[sender.tag]).cgColor
        iconCheckLabel.center = sender.center
    }
    
    @objc func TappedColorButton(_ sender: UIButton) {
        colorCheckLabel.layer.borderColor = UIColor(colorCode: colorList[sender.tag]).cgColor
        colorCheckLabel.center = sender.center
    }
}
