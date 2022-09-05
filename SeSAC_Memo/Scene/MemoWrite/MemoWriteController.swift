//
//  MemoWriteController.swift
//  SeSAC_Memo
//
//  Created by 최형민 on 2022/09/05.
//

import Foundation
import SnapKit
import UIKit
import Then
import RealmSwift
import MemoUIFramework

final class MemoWriteController: BaseViewController {
    
    let repository = UserMemoRepository()
    
    var selectedMemo: UserMemo?
    
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.BaseColor.background
        
        // 뒤로가기 제스쳐 delegate 추가
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationController?.navigationBar.tintColor = Constants.BaseColor.button
        
        self.textView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // view가 dismissed 될 때 텍스트 내용 저장
        
        // 메모 추가/수정
        addFixMemo()
        
    }
    
    override func configureUI() {
        super.configureUI()
        
        textView.do {
            $0.backgroundColor = Constants.BaseColor.background
            $0.textColor = Constants.BaseColor.text
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 16)
        }
        
        view.addSubview(textView)
        
        configureNavigationController()
        
        isNewMemo()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        textView.snp.makeConstraints {
            $0.topMargin.leadingMargin.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottomMargin.trailingMargin.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    @objc func shareButtonClicked() {
        let shareContent = textView.text ?? ""
                
        let vc = UIActivityViewController(activityItems: [shareContent], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func doneButtonClicked() {
        self.navigationItem.rightBarButtonItems = nil
    }
    
    
}

extension MemoWriteController {
    func isNewMemo() {
        if selectedMemo == nil {
            // 키보드 자동으로 띄워줌
            textView.becomeFirstResponder()
        } else {
            let text = selectedMemo!.memoContent == "추가 텍스트 없음" ? "" : selectedMemo!.memoContent
            textView.text = selectedMemo!.memoTitle + "\n" + text!
        }
    }
    
    // 코드 개선 필요!!
    // 메모 등록/수정
    func addFixMemo() {
        var memo: UserMemo?
        
        // 신규 등록
        if selectedMemo == nil {
            if let text = textView.text {
                // 리턴키가 눌린 시점으로 문장 나누기
                let dividedString: [String] = text.components(separatedBy: "\n")
                var newContent: String
                
                newContent = dividedString.count < 2 ? "추가 텍스트 없음" : dividedString[1]
                
                memo = UserMemo(memoTitle: dividedString[0], memoContent: newContent, writtenDate: Date())
                    
                self.repository.addMemo(item: memo!)
            } else if let text = textView.text {
                // 리턴키가 눌린 시점으로 문장 나누기
                let dividedString: [String] = text.components(separatedBy: "\n")
                
                if dividedString.count < 2 {
                    try! self.repository.localRealm.write {
                        selectedMemo?.memoTitle = dividedString[0]
                        selectedMemo?.memoContent = "추가 데이터 없음"
                        selectedMemo?.writtenDate = Date()
                        // pinned는 자동으로 false로 지정
                    }
                } else {
                    try! self.repository.localRealm.write {
                        selectedMemo?.memoTitle = dividedString[0]
                        selectedMemo?.memoContent = dividedString[1]
                        selectedMemo?.writtenDate = Date()
                    }
                }
            }
            // textView가 비어있을 때
        } else {
            self.repository.deleteItem(item: selectedMemo!)
        }
    }
    
//    func addGestureRecognizer() -> UITapGestureRecognizer {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
//        return tapGestureRecognizer
//    }

}

extension MemoWriteController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonClicked))
        self.navigationController?.navigationBar.tintColor = Constants.BaseColor.button
        
        let items = [doneButton, shareButton]
        self.navigationItem.rightBarButtonItems = items
    }
}

// 뒤로가기 제스처 등록하기 위해 delegate 프로토콜 등록
extension MemoWriteController: UIGestureRecognizerDelegate {
    
}
