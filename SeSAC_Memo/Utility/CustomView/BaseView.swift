//
//  BaseView.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/02.
//

import UIKit
import SnapKit
import Then

class BaseView: UIView {
    
    override init(frame: CGRect) {
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI() {}
    
    func setConstraints() {}
}
