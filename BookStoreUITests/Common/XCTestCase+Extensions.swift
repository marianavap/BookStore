//
//  XCTestCase+Extensions.swift
//  BookStoreUITests
//
//  Created by Mariana V. A. Souza on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

extension XCTestCase {
    /// Wait an element exists to start interact with it.
    ///
    /// - Parameters:
    ///   - element: Current element
    ///   - scrollElement: Elemento to scroll to search
    ///   - timeout: Optional timeout. Default value is 10 seconds.
    ///   - scrollAttempts: Attempts. Default is 3
    func waitElementExists(element: XCUIElement,
                           scrollElement: XCUIElement? = nil,
                           timeout: TimeInterval = 5,
                           scrollAttempts: Int = 3) {
        
        var exists = element.waitForExistence(timeout: timeout)
        
        if let scrollElement = scrollElement {
            for _ in 2...scrollAttempts {
                if exists {
                    return
                }
                scrollElement.swipeUp()
                exists = element.waitForExistence(timeout: timeout)
            }
        }
        
        XCTAssertTrue(exists, "Element \"\(element)\" was not found")
    }
}
