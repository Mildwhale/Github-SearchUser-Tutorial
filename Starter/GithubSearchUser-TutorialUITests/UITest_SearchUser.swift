//
//  UITest_SearchUser.swift
//  GithubSearchUser-TutorialUITests
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import XCTest

class UITest_SearchUser: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        
    }

    /// 검색어를 입력하면, 검색 결과를 확인할 수 있는가?
    func test_SearchUserResultAvailable() {
        /*
         테스트 시나리오
         
         1. SearchBar의 TextField를 탭
         2. 검색어 입력
         3. 검색 결과가 있는지 확인
         */
    }
    
    /// 검색어를 삭제하면, 검색 결과가 초기화 되는가?
    func test_CanResetSearchResult() {
        /*
        테스트 시나리오
        
        1. SearchBar의 TextField를 탭
        2. 검색어 입력
        3. 검색 결과가 있는지 확인
        4. 검색어 삭제
        5. 검색 결과가 없는지 확인
        */
    }
    
    /// 검색 결과 목록 중, 하나를 터치하면 상세 화면으로 이동하는가?
    func test_SearchAndEnterDetailView() {
        /*
        테스트 시나리오
        
        1. SearchBar의 TextField를 탭
        2. 검색어 입력
        3. 검색 결과가 있는지 확인
        4. 첫 번째 셀 터치가 가능한지 확인
        5. 첫 번째 셀을 터치
        6. 상세 화면으로 이동하는지 확인
        */
    }
    
    /// 검색 결과를 받아왔을 때, 테이블 뷰를 스크롤하면 페이지네이션이 동작하는가?
    func test_CanSearchResultPagination() {
        /*
        테스트 시나리오
        
        1. SearchBar의 TextField를 탭
        2. 검색어 입력
        3. 검색 결과가 있는지 확인
        4. 테이블 뷰를 상단으로 스크롤
        5. 다음 페이지가 테이블 뷰의 하단에 추가되었는지 확인
        */
    }
}
