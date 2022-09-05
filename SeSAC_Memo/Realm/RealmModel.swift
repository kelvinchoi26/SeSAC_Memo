//
//  RealmModel.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/04.
//

import Foundation
import RealmSwift

// @Persisted: Column

class UserMemo: Object {
    @Persisted var memoTitle: String // 제목(필수)
    @Persisted var memoContent: String? // 내용(옵션)
    @Persisted var writtenDate = Date() // 작성 날짜(필수)
    @Persisted var pinned: Bool // 즐겨찾기(필수)
    
    // PK(필수): 타입: Int, UUID, ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(memoTitle: String, memoContent: String?, writtenDate: Date) {
        self.init()
        self.memoTitle = memoTitle
        self.memoContent = memoContent
        self.writtenDate = writtenDate
        self.pinned = false
    }
}
