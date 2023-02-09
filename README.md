# iPhone 기본 메모 앱 클론
- [프로젝트 노션 링크](https://organized-elderberry-847.notion.site/feb318c64d8741d9be44121fb7cd9a3e)
- 진행 기간: 2022/08/31 → 2022/09/05
- 프로젝트 인원: 개인 프로젝트
- 한 줄 소개: 그래프를 통해 내 체중과 섭취칼로리 변화를 파악하고 건강 앱을 연동해 활동칼로리를 확인해볼 수 있는 운동일지 앱

## 🛠️ 사용 기술 및 라이브러리

- Swift, iOS, UIKit, AutoLayout, TableView, MVC
- Realm, SnapKit, Then, IQKeyboardManager

## 👾 개발 사항

- **Realm**을 활용해서 **CRUD** 기능 구현
- 스토리보드 없이 **Snapkit**으로 오토레이아웃 구현 (**Then** 라이브러리 활용)
- **다크 모드 / 라이트 모드** 대응
- UISearchController(**UISearchResultsUpdating**) 활용해 **메모 검색 기능** 구현

| <center>메인 화면</center> | <center>검색 기능</center> | <center>메모 쓰기</center> | <center>공유 기능</center>
|---|---|---|---|
| ![a1](https://user-images.githubusercontent.com/70970222/217817325-02f59417-0996-41c5-8274-b5ea120af946.png) | ![a2](https://user-images.githubusercontent.com/70970222/217816862-323b49cd-d705-4bd9-a41b-64d80fa9c366.png) | ![a3](https://user-images.githubusercontent.com/70970222/217816857-1387527f-24e7-4396-a76e-781e79598c04.png) | ![a4](https://user-images.githubusercontent.com/70970222/217816834-9c09387a-2f28-4550-a679-e24c4dc3882f.png)

##  앱 기능 설명

**[메모 고정 기능]**

- 메모의 tableView를 swipe하여 해당 메모 고정 및 고정 해제

**[메모 삭제 기능]**

- 메모의 tableView를 swipe하여 해당 메모 삭제

**[Realm을 통한 메모 데이터 관리]**

- Realm Query를 통해 메모 데이터 생성/수정/삭제 구현

**[메모 검색 기능]**

- 메모의 제목과 본문 내용에 대한 검색 기능 구현

