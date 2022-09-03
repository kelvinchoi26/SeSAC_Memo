//
//  AlertViewController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/02.
//

import Foundation
import Then

class AlertViewController: BaseViewController {
    
    let alertView = AlertView()
    
    override func loadView() {
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
