//
//  MemoSearchViewController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/04.
//

import Foundation

class MemoSearchViewController: BaseViewController {
    override func viewDidLoad() {
        if userDefaults.bool(forKey: "NotFirst") == false {
            
            userDefaults.set(true, forKey: "NotFirst")
            
            let popUpVC = AlertViewController()
            popUpVC.modalPresentationStyle = .overCurrentContext
            
            self.present(popUpVC, animated: true, completion: nil)
        }
    }
    
}

extension MemoSearchViewController {
    func configureNavigationBar {
        
    }
}
