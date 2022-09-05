//
//  AlertViewController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/02.
//

import Foundation
import Then

final class AlertViewController: BaseViewController {
    
    let alertView = AlertView()
    
    override func loadView() {
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.backgroundColor = .clear
        view.isOpaque = false
        
        alertView.backgroundColor = Constants.BaseColor.background
        alertView.layer.cornerRadius = Constants.Design.cornerRadius
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        alertView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.width.equalTo(view.snp.width).multipliedBy(0.7)
            $0.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }
    
}
