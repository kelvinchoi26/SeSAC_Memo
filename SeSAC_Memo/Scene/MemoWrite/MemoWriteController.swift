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
            $0.font = .boldSystemFont(ofSize: 16)
        }
        
        view.addSubview(textView)
        
        configureNavigationController()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        textView.snp.makeConstraints {
            $0.topMargin.leadingMargin.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottomMargin.trailingMargin.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    override func configureNavigationController() {
        super.configureNavigationController()
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonClicked))
        self.navigationController?.navigationBar.tintColor = Constants.BaseColor.button
        
        let items = [doneButton, shareButton]
        self.navigationItem.rightBarButtonItems = items
    }
    
    @objc func shareButtonClicked() {
        
    }
    
    @objc func doneButtonClicked() {
        
    }
}
