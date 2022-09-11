//
//  AlertViewController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/02.
//

import Foundation
import Then
import UIKit

final class WalkThroughViewController: BaseViewController {
    
    let alertView = WalkThroughView()
    
    override func loadView() {
        super.loadView()
        
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
