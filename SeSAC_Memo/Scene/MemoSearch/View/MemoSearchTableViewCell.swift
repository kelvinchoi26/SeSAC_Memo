//
//  MemoSearchTableViewCell.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/04.
//

import Foundation
import Then
import UIKit

class MemoSearchTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
    let stackView = UIStackView()
    
    override func configureUI() {
        self.backgroundColor = Constants.BaseColor.tableViewGray
        self.layer.cornerRadius = 8
        
        titleLabel.do {
            $0.textColor = Constants.BaseColor.text
            $0.font = .boldSystemFont(ofSize: 16)
        }
        
        contentLabel.do {
            $0.textColor = Constants.BaseColor.text
            $0.font = .systemFont(ofSize: 14)
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .top
            $0.distribution = .fillEqually
            $0.spacing = 4
        }
        
        contentView.addSubview(stackView)
        
        [titleLabel, contentLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: UserMemo) {
        titleLabel.text = data.memoTitle
        
        let dayDiff = numberOfDaysBetween(data.writtenDate)
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier:"ko_KR")
            return formatter
        }()
        
        switch dayDiff {
        case 0:
            formatter.dateFormat = "a hh:mm"
            let dateString = formatter.string(from: data.writtenDate)
            contentLabel.text = "\(dateString)  \(data.memoContent ?? "추가 텍스트 없음")"
        case 1...6:
            formatter.dateFormat = "E요일"
            let dateString = formatter.string(from: data.writtenDate)
            contentLabel.text = "\(dateString)  \(data.memoContent ?? "추가 텍스트 없음")"
        default:
            formatter.dateFormat = "yyyy. MM. dd a hh:mm"
            let dateString = formatter.string(from: data.writtenDate)
            contentLabel.text = "\(dateString)  \(data.memoContent ?? "추가 텍스트 없음")"
        }
    }
    
    func returnDateLabel(date: Date) -> String {
        let dayDiff = numberOfDaysBetween(date)
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier:"ko_KR")
            return formatter
        }()
        
        switch dayDiff {
        case 0:
            formatter.dateFormat = "a hh:mm"
            let dateString = formatter.string(from: date)
            return dateString
        case 1...6:
            formatter.dateFormat = "E요일"
            let dateString = formatter.string(from: date)
            return dateString
        default:
            formatter.dateFormat = "yyyy. MM. dd a hh:mm"
            let dateString = formatter.string(from: date)
            return dateString
        }
    }
    
    override func setConstraints() {
        let spacing = 10
        
        stackView.snp.makeConstraints {
            $0.height.equalTo(contentView).inset(spacing)
            $0.leadingMargin.top.equalTo(spacing)
            $0.bottom.equalTo(-spacing)
            $0.trailingMargin.equalTo(-spacing)
        }
    }
    
}
