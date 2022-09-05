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
            print("current tasks: \(tasks)")
            // 핵심 ***
            // 계속해서 값 갱신 필수!
            pinnedMemo = repository.fetchFilter()
            unPinnedMemo = repository.fetchDeFilter()
            numOfPinnedMemo = pinnedMemo?.count ?? 0
            
            tableView.reloadData()
            
            // 제목 개수 업데이트
            configureNavigationController()
        }
    }
    
    var pinnedMemo: Results<UserMemo>?
    
    var unPinnedMemo: Results<UserMemo>?
    
    // 검색된 메모들
    var searchedMemo: Results<UserMemo>?
    
    // 고정된 메모가 5개인 경우 토스트를 사용해서 불가능하다고 알림
    var numOfPinnedMemo: Int = 0
    
    // searchBar에 입력중인지 여
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
        fetchRealm()
        
//        checkInitialRun()
        
        print("Realm is located at: ", repository.localRealm.configuration.fileURL!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationController()
        
        fetchRealm()
        tableView.reloadData()
        
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
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        
        
        self.navigationItem.title = "\(count ?? "0")개의 메모"
        self.navigationItem.titleView?.tintColor = Constants.BaseColor.text
        self.navigationItem.titleView?.backgroundColor = Constants.BaseColor.navigationBar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let backButtonItem = UIBarButtonItem(title: "검색", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        
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
    
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        writeButton.tintColor = Constants.BaseColor.button
        writeButton.customView?.backgroundColor = Constants.BaseColor.button
        
        self.navigationController?.toolbar.barTintColor = .red
        
        var items = [UIBarButtonItem]()
        
        [flexibleSpace, writeButton].forEach {
            items.append($0)
        }
        
        self.toolbarItems = items
        
    }
    
    @objc func writeButtonClicked() {
        let backButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        
        let vc = MemoWriteController()

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MemoSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isSearching ? 1 : numOfPinnedMemo > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = tasks?.count
        
        // 검색하고 있는 경우
        if self.isSearching {
            return searchedMemo?.count ?? 0
        } else {
            // 하나의 섹션만 표시되는 경우
            if numOfPinnedMemo == 0 || count == numOfPinnedMemo {
                return count ?? 0
            } else {
                // 두 개 모두 표시되는 경우
                return section == 1 ? count! - numOfPinnedMemo : numOfPinnedMemo
            }
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor = .black

        let label = UILabel(frame: CGRect(x: 8, y: 0, width: view.frame.width, height: 50))

        if self.isSearching {
            label.text = "\(self.searchedMemo?.count ?? 0)개 찾음"
        } else {
            if numOfPinnedMemo == 0 && tasks!.count == 0 {
                return nil
            } else if numOfPinnedMemo == tasks!.count {
                label.text = "고정된 메모"
            } else {
                label.text = section == 0 ? "고정된 메모" : "메모"
            }
        }

        label.textColor = Constants.BaseColor.text
        label.font = .boldSystemFont(ofSize: 24)

        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MemoSearchTableViewCell else { return UITableViewCell() }
        
        // 검색 중 일 때 tableView update
        if self.isSearching {
            let memo = searchedMemo?[indexPath.row]
            let title = memo!.memoTitle
            
            let dateLabel = cell.returnDateLabel(date: memo!.writtenDate)
            // 날짜 String까지도 검색어에 포함되는 문제 발생....!!!
            let content = "\(dateLabel)  \(String(describing: memo!.memoContent))"
            
            let searchedText = self.navigationItem.searchController?.searchBar.text ?? ""
            
            let highlightedColor = Constants.BaseColor.button
            
            let attributedTitleString = NSMutableAttributedString(string: title)
            let attributedContentString = NSMutableAttributedString(string: content)
            
            attributedTitleString.addAttribute(.foregroundColor, value: highlightedColor!, range: (title as NSString).range(of: searchedText))
            attributedContentString.addAttribute(.foregroundColor, value: highlightedColor!, range: (content as NSString).range(of: searchedText))
            
            cell.titleLabel.attributedText = attributedTitleString
            cell.contentLabel.attributedText = attributedContentString
            
            // 검색하지 않을 때 tableView update
        } else {
            var memo = UserMemo()
            
            // 고정 메모가 없는 경우
            if numOfPinnedMemo == 0 {
                memo = tasks![indexPath.row]
            } else {
                if indexPath.section == 1 {
                    memo = unPinnedMemo![indexPath.row]
                } else {
                    memo = pinnedMemo![indexPath.row]
                }
            }
            
            cell.setData(data: memo)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pinned = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            // realm data update
            self.repository.updatePinned(item: self.tasks![indexPath.row])
            self.tasks = self.repository.fetch()
            
        }
        
        // realm 데이터 기준
        let image = tasks![indexPath.row].pinned ? "pin.fill" : "pin.slash.fill"
        pinned.image = UIImage(systemName: image)
        pinned.backgroundColor = Constants.BaseColor.button
        
        
        return UISwipeActionsConfiguration(actions: [pinned])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
//        let memo = self.tasks[indexPath.row]
//        ]
        let delete = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            // 사진 먼저 지우고 램 지우면 문제가 안생겼던 이유
            
            self.repository.deleteItem(item: self.tasks![indexPath.row])
            self.tasks = self.repository.fetch()
        }

        // realm 데이터 기준
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = Constants.BaseColor.trash
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MemoWriteController()
        
        if indexPath.section == 0 {
            vc.memo = pinnedMemo![indexPath.row]
        } else {
            vc.memo = unPinnedMemo![indexPath.row]
        }
        

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MemoSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        self.searchedMemo = fetchSearched(text: text)
        self.tableView.reloadData()
    }
    
    func fetchSearched(text: String) -> Results<UserMemo> {
        return self.tasks!.filter("memoTitle CONTAINS '\(text)' or memoContent CONTAINS '\(text)'").sorted(byKeyPath: "writtenDate", ascending: true)
    }
}
