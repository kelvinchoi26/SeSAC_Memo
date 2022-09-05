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
    let stackView = UIStackView()
    let containerView = UIView()

    override func configureUI() {
        super.configureUI()
        
        containerView.do {
            $0.backgroundColor = Constants.BaseColor.background
            $0.layer.cornerRadius = 8
        }
        
        textLabel.do {
            $0.numberOfLines = 0
            $0.text = Constants.Text.alertText
            $0.textColor = Constants.BaseColor.text
            $0.font = .boldSystemFont(ofSize: 20)
        }
        
        okButton.do {
            $0.backgroundColor = Constants.BaseColor.button
            $0.tintColor = Constants.BaseColor.text
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(Constants.BaseColor.text, for: .normal)
            $0.layer.borderWidth = Constants.Design.borderWidth
            $0.layer.cornerRadius = Constants.Design.cornerRadius
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .top
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        self.addSubview(containerView)
        
        [textLabel, okButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        containerView.addSubview(stackView)
        
        self.layer.borderWidth = Constants.Design.borderWidth
        self.layer.borderColor = Constants.BaseColor.border
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let spacing = 10
        
        containerView.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
            $0.height.equalTo(self.snp.width).multipliedBy(0.3)
            $0.width.equalTo(self.snp.height).multipliedBy(0.7)
        }
        
        stackView.snp.makeConstraints {
            $0.leadingMargin.topMargin.equalTo(spacing)
            $0.trailingMargin.bottomMargin.equalTo(-spacing)
        }
    }
    
}
