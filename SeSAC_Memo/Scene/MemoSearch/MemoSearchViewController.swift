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
import Toast

final class MemoSearchViewController: BaseViewController {
    
    let repository = UserMemoRepository()
    
    var tasks: Results<UserMemo>? {
        didSet {
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
    
    // searchBar에 입력중인지 여부
    var isSearching: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        var searchBarContainsText = searchController?.searchBar.text?.isEmpty
        
        // isEmpty가 아닌 경우로 바꿔줌
        searchBarContainsText?.toggle()
        
        return isActive && searchBarContainsText!
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .insetGrouped)
        view.backgroundColor = .clear
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets()
        view.delegate = self
        view.dataSource = self
        view.register(MemoSearchTableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Realm 데이터를 정렬해 tasks에 담기
        fetchRealm()
        
        
        print("Realm is located at: ", repository.localRealm.configuration.fileURL!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkInitialRun()
        
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
        self.navigationItem.titleView?.tintColor = Constants.BaseColor.background
        self.navigationItem.titleView?.backgroundColor = Constants.BaseColor.tableViewGray
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let backButtonItem = UIBarButtonItem(title: "검색", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        
    }
    
}

extension MemoSearchViewController {
    // 첫 실행인지 확인 후 Alert 띄우기
    func checkInitialRun() {
        if !userDefaults.bool(forKey: "NotFirst") {
            
            userDefaults.set(true, forKey: "NotFirst")
            
            let popUpVC = WalkThroughViewController()
            popUpVC.modalPresentationStyle = .overFullScreen
            
            self.present(popUpVC, animated: true)
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
    
    func showPinnedAlert() {
        let alert = UIAlertController(title: "", message: "고정 메모는 5개까지만 가능합니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.tableView.setEditing(false, animated: true)
        }
        
        alert.addAction(ok)
        
        self.present(alert, animated: true)
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
        view.backgroundColor = Constants.BaseColor.background

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
        
        var memo = UserMemo()
        
        let action = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            if indexPath.section == 1 && self.numOfPinnedMemo >= 5 {
                self.showPinnedAlert()
            } else {
                if self.numOfPinnedMemo == 0 {
                    memo = self.tasks![indexPath.row]
                } else {
                    memo = indexPath.section == 1 ? self.unPinnedMemo![indexPath.row] : self.pinnedMemo![indexPath.row]
                }
            }
            
            self.repository.updatePinned(item: memo)
            self.tasks = self.repository.fetch()
        }
        
        action.image = indexPath.section == 0 ? UIImage(systemName: "pin.slash.fill") : UIImage(systemName: "pin.fill")
        
        action.backgroundColor = Constants.BaseColor.button
        
        return UISwipeActionsConfiguration(actions: [action])
    }
        
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var memo = UserMemo()
        
        let delete = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            let row = indexPath.row
            
            if self.numOfPinnedMemo == 0 {
                memo = self.tasks![row]
            } else {
                memo = indexPath.section == 1 ? self.unPinnedMemo![row] : self.pinnedMemo![row]
            }
            
            let alert = UIAlertController(title: "", message: "정말 삭제하시겠습니다?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
                self.repository.deleteItem(item: memo)
                self.tasks = self.repository.fetch()
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
                // 테이블 뷰 편집 모드 종료
                self.tableView.setEditing(false, animated: true)
            }
            
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true)
        }

        // realm 데이터 기준
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = Constants.BaseColor.trashCan
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MemoWriteController()
        
        if indexPath.section == 0 {
            vc.selectedMemo = pinnedMemo![indexPath.row]
        } else {
            vc.selectedMemo = unPinnedMemo![indexPath.row]
        }
        

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
