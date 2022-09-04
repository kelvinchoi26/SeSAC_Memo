//
//  BaseTableViewCell.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/01.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = .darkGray
        self.tintColor = .darkGray
    }
    
    func setConstraints() {}
    
    func numberOfDaysBetween(_ writtenDate: Date) -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let tempCurrentDate = formatter.string(from: Date())
        let tempMemoDate = formatter.string(from: writtenDate)
        
        let currentDate = formatter.date(from: tempCurrentDate)
        let memoDate = formatter.date(from: tempMemoDate)
        
        let interval = memoDate!.timeIntervalSince(currentDate!)
        let days = Int(interval / 86400)
        
        return days
    }
}
