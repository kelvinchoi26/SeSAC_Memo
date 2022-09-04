//
//  MemoWriteController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/05.
//

import Foundation
import SnapKit
import UIKit
import Then
import RealmSwift
import MemoUIFramework

final class MemoWriteController: BaseViewController {
    
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.BaseColor.background
    }
    
    override func configureUI() {
        super.configureUI()
        
        textView.do {
            $0.backgroundColor = Constants.BaseColor.background
            $0.textColor = Constants.BaseColor.text
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 14)
        }
        
        view.addSubview(textView)
        
        configureNavigationController()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        textView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureNavigationController() {
        super.configureNavigationController()
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "sqaure.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonClicked))
        self.navigationController?.navigationBar.tintColor = Constants.BaseColor.button
        
        let items = [shareButton, doneButton]
        self.navigationItem.rightBarButtonItems = items
    }
    
    @objc func shareButtonClicked() {
        
    }
    
    @objc func doneButtonClicked() {
        
    }
}
