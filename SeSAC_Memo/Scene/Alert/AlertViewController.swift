//
//  AlertViewController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/02.
//

import Foundation
import Then
import UIKit

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
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        
        alertView.backgroundColor = Constants.BaseColor.gray
        alertView.layer.cornerRadius = Constants.Design.cornerRadius
        alertView.layer.borderWidth = Constants.Design.borderWidth
        alertView.layer.borderColor = UIColor.white.cgColor
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
