//
//  MemoSearchView.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/04.
//

import Foundation
import UIKit

final class MemoSearchView: BaseView {
    
    var searchBar = UISearchBar()
    var tableView = UITableView()
    
    override func configureUI() {
        searchBar.do {
            $0.placeholder = "검색"
            $0.searchTextField.font = .systemFont(ofSize: 14)
            $0.searchTextField.backgroundColor = .clear
        }
        
        
    }
}
