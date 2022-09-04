//
//  BaseViewController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/08/31.
//

import Foundation

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationController()
    }

    func configureNavigationController() { }
    
    func configureUI() {}
    
    func setConstraints() { }
    
}
