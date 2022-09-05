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
import MemoUIFramework

final class MemoSearchViewController: BaseViewController {
    
    let repository = UserMemoRepository()
    
    var tasks: Results<UserMemo>? {
        didSet {
            pinnedMemo = repository.fetchFilter()
            unPinnedMemo = repository.fetchDeFilter()
            numOfPinnedMemo = pinnedMemo?.count ?? 0
            
            // 제목 개수 업데이트
            configureNavigationController()
            
            tableView.reloadData()
        }
    }
    
    var pinnedMemo: Results<UserMemo>?
    
    var unPinnedMemo: Results<UserMemo>?
    
    // 검색된 메모들
    var searchedMemo: Results<UserMemo>?
    
    // 고정된 메모가 5개인 경우 토스트를 사용해서 불가능하다고 알림
    var numOfPinnedMemo: Int = 0
    
    var isSearching: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        var searchBarContainsText = searchController?.searchBar.text?.isEmpty
        
        // isEmpty가 아닌 경우로 바꿔줌
        searchBarContainsText?.toggle()
        
        return isActive && searchBarContainsText!
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 50
        view.delegate = self
        view.dataSource = self
        view.register(MemoSearchTableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Realm 데이터를 정렬해 tasks에 담기
        tasks = repository.fetch()
        
//        checkInitialRun()
        
        configureToolbar()
        
        print("Realm is located at: ", repository.localRealm.configuration.fileURL!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationController()
        
        fetchRealm()
        
        configureToolbar()
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.backgroundColor = Constants.BaseColor.background
        
        [tableView].forEach {
            view.addSubview($0)
        }
        
        configureToolbar()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(8)
            $0.trailing.equalTo(-8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureNavigationController() {
        super.configureNavigationController()
        
        // 3자리 마다 콤마 찍기
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let taskCount = tasks?.count ?? 0
        let count = formatter.string(from: taskCount as NSNumber)

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "\(count ?? "0")개의 메모"
        self.navigationItem.titleView?.tintColor = Constants.BaseColor.text
        self.navigationItem.titleView?.backgroundColor = Constants.BaseColor.navigationBar
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

extension MemoSearchViewController {
    // 첫 실행인지 확인 후 Alert 띄우기
    func checkInitialRun() {
        if userDefaults.bool(forKey: "NotFirst") == false {
            
            userDefaults.set(true, forKey: "NotFirst")
            
            let popUpVC = AlertViewController()
            popUpVC.modalPresentationStyle = .overCurrentContext
            
            self.present(popUpVC, animated: true, completion: nil)
        }
    }
    
    func fetchRealm() {
        tasks = repository.fetch()
    }
    
    func configureToolbar() {
        
        self.navigationController?.isToolbarHidden = false
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "sqaure.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        writeButton.tintColor = Constants.BaseColor.button
        
        var items = [UIBarButtonItem]()
        
        [flexibleSpace, writeButton].forEach {
            items.append($0)
        }
        
        self.navigationController?.toolbarItems = items
        
    }
    
    @objc func writeButtonClicked() {
        
    }
}

extension MemoSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        switch section {
        case 0:
            count = repository.countOfPinnedMemo()
        case 1:
            count = tasks?.count ?? 0
        default:
            break
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor = .black
        
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: view.frame.width, height: 50))
                            
        switch section {
        case 0:
            label.text = "고정된 메모"
        case 1:
            label.text = "메모"
        default:
            break
        }
        
        label.textColor = Constants.BaseColor.text
        label.font = .boldSystemFont(ofSize: 24)
               
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MemoSearchTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            let newTasks = repository.fetchFilter()
            cell.setData(data: (newTasks[indexPath.row]))
        case 1:
//            let newTasks = repository.fetchDeFilter()
            cell.setData(data: (tasks?[indexPath.row])!)
        default:
            break
        }
    
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

extension MemoSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        self.searchedMemo = repository.fetchSearched(text: text)
        self.tableView.reloadData()
    }
}
