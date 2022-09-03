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

        configure()
        setConstraints()
        configureNavigationController()
    }

    func configureNavigationController() { }
    
    func configure() {
        view.backgroundColor = Constants.BaseColor.background
    }
    
    func setConstraints() { }
    
}
