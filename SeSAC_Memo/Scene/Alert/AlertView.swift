//
//  AlertTextView.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/02.
//

import Foundation
import UIKit

final class AlertView: BaseView {
    
    let textLabel = UILabel()
    let okButton = UIButton()

    override func configureUI() {
        textLabel.do {
            $0.backgroundColor = Constants.BaseColor.view
            $0.text = Constants.Text.alertText
            $0.textColor = Constants.BaseColor.text
            $0.font = .systemFont(ofSize: Constants.FontSize.alertFont)
        }
        
        okButton.do {
            $0.tintColor = Constants.BaseColor.button
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(Constants.BaseColor.text, for: .normal)
            $0.layer.borderWidth = Constants.Design.borderWidth
            $0.layer.cornerRadius = Constants.Design.cornerRadius
        }
    }
    
    override func setConstraints() {
        textLabel.snp.makeConstraints {
            $0.topMargin.equalTo(20)
            $0.leadingMargin.equalTo(20)
            $0.trailingMargin.equalTo(-20)
            $0.height.equalTo(self).multipliedBy(0.7)
        }
        
        okButton.snp.makeConstraints {
            $0.topMargin.equalTo(textLabel.snp.bottom).offset(20)
            $0.leadingMargin.equalTo(20)
            $0.trailingMargin.equalTo(-20)
            $0.bottomMargin.equalTo(-20)
        }
    }
    
}
