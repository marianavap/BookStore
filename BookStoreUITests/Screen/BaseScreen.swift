//
//  BaseScreen.swift
//  BookStoreUITests
//
//  Created by Mariana V. A. Souza on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

protocol BaseScreen {
    
    /// Screen ui element
    static var screen: XCUIElement { get }
}

// MARK: - Common
extension BaseScreen {
    
    /// Waits screen to be shown
    ///
    /// - Parameter testCase: test case use to assert the screen presentation
    static func waitScreen(testCase: XCTestCase) {
        testCase.waitElementExists(element: screen)
    }
    
    /// Tap Navigation back button
    static func tapNavigationBackButton() {
        XCUIApplication().navigationBars.buttons.firstMatch.tap()
    }
}
