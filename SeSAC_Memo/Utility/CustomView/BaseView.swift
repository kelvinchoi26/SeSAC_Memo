//
//  BaseView.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/02.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = Constants.BaseColor.view
        view.text = "처음 오셨군요!\n 환영합니다 :)\n\n 당신만의 메모를 작성하고\n 관리해보세요!"
        view.textColor = Constants.BaseColor.text
        view.font = 
    }()
    
    override init(frame: CGRect) {
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI() {
        self.backgroundColor = Constants.BaseColor.background
    }
    
    func setConstraints() {}
}
