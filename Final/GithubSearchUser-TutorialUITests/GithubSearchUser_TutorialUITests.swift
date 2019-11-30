//
//  GithubSearchUser_TutorialUITests.swift
//  GithubSearchUser-TutorialUITests
//
//  Created by Wayne Kim on 2019/11/27.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import XCTest

class GithubSearchUser_TutorialUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch() // 앱 실행
    }

    override func tearDown() {
        
    }
    
    /// 검색어를 입력하면, 검색 결과를 확인할 수 있는가?
    func test_SearchUserResultAvailable() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists) // 검색창의 TextField가 있는지 확인
        
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("Mildwhale\n") // 2. 검색어 입력 후 키보드 내림
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
    }
    
    /// 검색어를 삭제하면, 검색 결과가 초기화 되는가?
    func test_CanResetSearchResult() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists) // 검색창의 TextField가 있는지 확인
        
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("Mildwhale\n") // 2. 검색어 입력 후 키보드 내림
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
        
        searchField.clearText() // 4. 검색어 삭제
        
        XCTAssertFalse(resultCellOfFirst.exists) // 5. 검색 결과가 없는지 확인
    }
    
    /// 검색 결과 목록 중, 하나를 터치하면 상세 화면으로 이동하는가?
    func test_SearchAndEnterDetailView() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists) // 검색창의 TextField가 있는지 확인
        
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("Mildwhale\n") // 2. 검색어 입력 후 키보드 내림
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
        
        XCTAssertTrue(resultCellOfFirst.isHittable) // 4. 첫 번째 셀 터치가 가능한지 확인
        resultCellOfFirst.tap() // 5. 첫 번째 셀을 터치
        
        let safariViewController = app.otherElements.webViews.firstMatch
        XCTAssertTrue(safariViewController.waitForExistence(timeout: 15.0)) // 6. 상세 화면으로 이동하는지 확인
    }
    
    /// 검색 결과를 받아왔을 때, 테이블 뷰를 스크롤하면 페이지네이션이 동작하는가?
    func test_CanSearchResultPagination() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists) // 검색창의 TextField가 있는지 확인
        
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("Hello\n") // 2. 검색어 입력 후 키보드 내림
        
        let resultCells = app.cells
        XCTAssertTrue(resultCells.firstMatch.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
        let firstResultsCount = resultCells.count // 첫 번째 페이지 셀의 개수를 저장
        
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists)
        
        tableView.swipeUp() // 4. 테이블 뷰를 상단으로 스크롤
        
        XCTAssertNotEqual(firstResultsCount, resultCells.count) // 5. 셀의 개수를 비교하여, 다음 페이지의 데이터가 추가되었는지 확인
    }
}
