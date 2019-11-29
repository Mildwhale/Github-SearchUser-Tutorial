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
    func testSearchUserResultAvailable() {
        let searchField = app.searchFields.firstMatch
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("Mildwhale\n") // 2. 검색어 입력 후 키보드 내림
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssert(resultCellOfFirst.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
    }
    
    /// 검색어를 삭제하면, 검색 결과가 초기화 되는가?
    func testCanResetSearchResult() {
        let searchField = app.searchFields.firstMatch
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("Mildwhale\n") // 2. 검색어 입력 후 키보드 내림
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssert(resultCellOfFirst.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
        
        searchField.clearText() // 4. 검색어 삭제
        
        XCTAssertFalse(resultCellOfFirst.exists) // 5. 검색 결과가 없는지 확인
    }
}
