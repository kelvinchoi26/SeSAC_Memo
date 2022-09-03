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
    let dateLabel = UILabel()
    let contentLabel = UILabel()
    
    override func configureUI() {
        titleLabel.do {
            $0.textColor = Constants.BaseColor.text
            $0.font = .boldSystemFont(ofSize: 13)
        }
        
        dateLabel.do {
            $0.textColor = Constants.BaseColor.memoText
            $0.font = .boldSystemFont(ofSize: 12)
        }
        
        contentLabel.do {
            $0.textColor = Constants.BaseColor.memoText
            $0.font = .boldSystemFont(ofSize: 12)
        }
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: UserMemo) {
        titleLabel.text = data.diaryTitle
        dateLabel.text = data.writtenDate.formatted()
        contentLabel.text = data.diaryContent
    }
    
    override func configure() {
        backgroundColor = Constants.BaseColor.background
        [diaryImageView, stackView].forEach {
            contentView.addSubview($0)
        }
        
        [titleLabel, dateLabel, contentLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraints() {
        let spacing = 8
        
        diaryImageView.snp.makeConstraints { make in
            make.height.equalTo(contentView).inset(spacing)
            make.width.equalTo(diaryImageView.snp.height)
            make.centerY.equalTo(contentView)
            make.trailingMargin.equalTo(-spacing)
        }
        
        stackView.snp.makeConstraints { make in
            make.leadingMargin.top.equalTo(spacing)
            make.bottom.equalTo(-spacing)
            make.trailing.equalTo(diaryImageView.snp.leading).offset(-spacing)
        }
    }
    

    
    
}
