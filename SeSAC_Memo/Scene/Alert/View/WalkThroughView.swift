//
//  AlertTextView.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/02.
//

import Foundation
import UIKit

final class WalkThroughView: BaseView {
    
    let textLabel = UILabel()
    let confirmButton = UIButton()
    let alertView = UIView()

    override func configureUI() {
        super.configureUI()
        
        alertView.do {
            $0.layer.cornerRadius = 20
        }
        
        textLabel.do {
            $0.numberOfLines = 0
            $0.text = Constants.Text.alertText
            $0.textColor = Constants.BaseColor.text
            $0.font = .boldSystemFont(ofSize: 16)
        }
        
        confirmButton.do {
            $0.backgroundColor = Constants.BaseColor.button
            $0.tintColor = Constants.BaseColor.text
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(Constants.BaseColor.text, for: .normal)
            $0.layer.borderWidth = Constants.Design.borderWidth
            $0.layer.cornerRadius = 16
        }
        
        self.addSubview(alertView)
        
        [textLabel, confirmButton].forEach {
            alertView.addSubview($0)
        }
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.layer.borderWidth = Constants.Design.borderWidth
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self)
            $0.width.equalTo(self.snp.height).multipliedBy(0.7)
            $0.height.equalTo(alertView.snp.width)
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(alertView).inset(20)
            $0.leading.trailing.equalTo(alertView).inset(25)
            $0.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
    
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(alertView).multipliedBy(0.2)
            $0.bottom.leading.trailing.equalTo(alertView).inset(20)
        }
    }
    
}
