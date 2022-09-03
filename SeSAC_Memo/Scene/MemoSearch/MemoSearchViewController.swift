//
//  MemoSearchViewController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/04.
//

import Foundation
import SnapKit
import UIKit
import Then
import RealmSwift

final class MemoSearchViewController: BaseViewController {
    
    var searchBar = UISearchBar()
    
    var tasks: Results<UserMemo>! {
        didSet {
            tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.register(MemoSearchTableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()

    
    let repository = UserMemoRepository()
    
    override func viewDidLoad() {
        
        // Realm 데이터를 정렬해 tasks에 담기
        tasks = repository.localRealm.objects(UserMemo.self).sorted(byKeyPath: "writtenDate", ascending: true)
        
        if userDefaults.bool(forKey: "NotFirst") == false {
            
            userDefaults.set(true, forKey: "NotFirst")
            
            let popUpVC = AlertViewController()
            popUpVC.modalPresentationStyle = .overCurrentContext
            
            self.present(popUpVC, animated: true, completion: nil)
        }
    }
    
    override func configureUI() {
        searchBar.do {
            $0.placeholder = "검색"
            $0.searchTextField.font = .systemFont(ofSize: 14)
            $0.searchTextField.backgroundColor = .clear
        }
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
}

extension MemoSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MemoSearchTableViewCell else { return UITableViewCell() }
        
        cell.setData(data: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pinned = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            // realm data update
            self.repository.updatePinned(item: self.tasks[indexPath.row])
            
        }
        
        // realm 데이터 기준
        let image = tasks[indexPath.row].pinned ? "pin.fill" : "pin.slash.fill"
        pinned.image = UIImage(systemName: image)
        pinned.backgroundColor = Constants.BaseColor.button
        
        return UISwipeActionsConfiguration(actions: [pinned])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            // 사진 먼저 지우고 램 지우면 문제가 안생겼던 이유
            
            self.repository.deleteItem(item: self.tasks[indexPath.row])
        }

        // realm 데이터 기준
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = Constants.BaseColor.trash
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
