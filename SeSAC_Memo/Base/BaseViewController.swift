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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configure()
        setConstraints()
        configureNavigationController()
    }

    func configureNavigationController() { }
    
    func configure() { }
    
    func setConstraints() { }
    
}
