# iPhone 기본 메모 앱 클론
- [프로젝트 노션 링크](https://organized-elderberry-847.notion.site/feb318c64d8741d9be44121fb7cd9a3e)
- 진행 기간: 2022/08/31 → 2022/09/05
- 프로젝트 인원: 개인 프로젝트
- 한 줄 소개: iPhone 기본 앱의 기능들을 참고하여 구현

***

## 🛠️ 사용 기술 및 라이브러리

- Swift, iOS, UIKit, AutoLayout, TableView, MVC
- Realm, SnapKit, Then, IQKeyboardManager

***

## 👾 개발 사항

- **Realm**을 활용해서 **CRUD** 기능 구현
- 스토리보드 없이 **Snapkit**으로 오토레이아웃 구현 (**Then** 라이브러리 활용)
- **다크 모드 / 라이트 모드** 대응
- UISearchController(**UISearchResultsUpdating**) 활용해 **메모 검색 기능** 구현

| <center>메인 화면</center> | <center>검색 기능</center> | <center>메모 쓰기</center> | <center>공유 기능</center>
|---|---|---|---|
| ![a1](https://user-images.githubusercontent.com/70970222/217817325-02f59417-0996-41c5-8274-b5ea120af946.png) | ![a2](https://user-images.githubusercontent.com/70970222/217816862-323b49cd-d705-4bd9-a41b-64d80fa9c366.png) | ![a3](https://user-images.githubusercontent.com/70970222/217816857-1387527f-24e7-4396-a76e-781e79598c04.png) | ![a4](https://user-images.githubusercontent.com/70970222/217816834-9c09387a-2f28-4550-a679-e24c4dc3882f.png)

***

## 회고 / 트러블 슈팅

### 💌 오픈소스 라이브러리 활용

- Storyboard로 UI를 만들다 처음으로 **Snapkit**과 **Then**을 활용
    - Interface Builder에 비해 코드는 전체적인 제약조건을 파악하기에 쉬움
- **IQKeyboardManager** 활용
    - 별도 구현 없이 텍스트 필드 또는 텍스트 뷰 입력 시 view가 가려지는 현상 방지
    - 별도 구현 없이 화면 아무 곳이나 누르면 키보드 dismiss 실행

### 🎓 Heavy한 뷰컨트롤러 코드

- ViewController 코드에서 tableView의 삭제/고정 기능, 고정된 Memo 객체들 관리, 검색 기능, UI까지 관리해 코드가 400줄이 넘음
    - 에러 해결을 위해 디버깅 시 어느 부분이 문제인지 파악이 어려웠음
    - 전체적인 코드 관리의 어려움
        - 어느 부분이 UI 코드, 비즈니스 로직 파트인지 구분이 어려웠음

***

##  앱 기능 설명

**[메모 고정 기능]**

- 메모의 tableView를 swipe하여 해당 메모 고정 및 고정 해제

**[메모 삭제 기능]**

- 메모의 tableView를 swipe하여 해당 메모 삭제

**[Realm을 통한 메모 데이터 관리]**

- Realm Query를 통해 메모 데이터 생성/수정/삭제 구현

**[메모 검색 기능]**

- 메모의 제목과 본문 내용에 대한 검색 기능 구현

