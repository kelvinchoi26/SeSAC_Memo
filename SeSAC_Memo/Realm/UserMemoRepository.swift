//
//  UserMemoRepository.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/04.
//

import Foundation
import RealmSwift

// 여러 개의 테이블 -> CRUD
protocol UserMemoRepositoryType {
    func fetch() -> Results<UserMemo>
    func updatePinned(item: UserMemo)
    func deleteItem(item: UserMemo)
}

// 어떤 메서드가 있는지 보기 편하게 프로토콜로 만들어둠
class UserMemoRepository: UserMemoRepositoryType {
    
    let localRealm = try! Realm() // struct ->
    
    func fetch() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).sorted(byKeyPath: "writtenDate", ascending: true)
    }
    
    func updatePinned(item: UserMemo) {
        try! localRealm.write {
            // 하나의 레코드에서 특정 컬럼 하나만 변경
            item.pinned.toggle()
        }
    }
    
    func deleteItem(item: UserMemo) {
        try! localRealm.write {
            localRealm.delete(item) // 10
        }
    }
    
    func countOfPinnedMemo() -> Int {
        let data = localRealm.objects(UserMemo.self).filter("pinned == true")
        return data.count
    }
    
    func fetchFilter() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).filter("pinned == true")
    }
    
    func fetchDeFilter() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).filter("pinned == false")
    }
    
}
