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
    @Persisted var diaryTitle: String // 제목(필수)
    @Persisted var diaryContent: String? // 내용(옵션)
    @Persisted var writtenDate = Date() // 작성 날짜(필수)
    @Persisted var pinned: Bool // 즐겨찾기(필수)
    
    // PK(필수): 타입: Int, UUID, ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(diaryTitle: String, diaryContent: String?, writtenDate: Date) {
        self.init()
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.writtenDate = writtenDate
        self.pinned = false
    }
}
