//
//  UITestHelper.swift
//  GithubSearchUser-TutorialUITests
//
//  Created by Wayne Kim on 2019/11/30.
//  Copyright © 2019 Wayne Kim. All rights reserved.
//

import XCTest

extension XCUIElement {
    // https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
    func clearText() {
        guard let stringValue = value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        if hasFocus == false {
            guard isHittable else {
                XCTFail("Can't hit element. \(isHittable)")
                return
            }
            tap()
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

extension XCUIElement {
    private func waitForPredicate(format: String, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: format)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let waiter = XCTWaiter()

        switch waiter.wait(for: [expectation], timeout: timeout) {
        case .completed:
            return true
        default:
            return false
        }
    }
    
    func waitForEnable(timeout: TimeInterval) -> Bool {
        return waitForPredicate(format: "enabled == true", timeout: timeout)
    }
    
    func waitForFocus(timeout: TimeInterval) -> Bool {
        return waitForPredicate(format: "hasKeyboardFocus == true", timeout: timeout)
    }
    
    var hasFocus: Bool {
        let hasKeyboardFocus = (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        return hasKeyboardFocus
    }
}
