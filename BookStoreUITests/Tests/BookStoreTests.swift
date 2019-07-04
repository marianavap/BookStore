//
//  BookStoreTests.swift
//  BookStoreUITests
//
//  Created by Smiles on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

class BookStoreTests: BaseTests {
    
    override func setUp() {
        super.setUp()
        BookListScreen.waitScreen(testCase: self)
    }
    
    func testCollectionDidLoad() {
        waitElementExists(element: BookListScreen.visibleBookCell())
    }
    
    func testDetails() {
        let cell = BookListScreen.notVisibleBookCell()
        waitElementExists(element: cell, scrollElement: BookListScreen.screen, timeout: 2)
        cell.tap()
        BookScreen.waitScreen(testCase: self)
        BookScreen.tapNavigationBackButton()
        BookListScreen.waitScreen(testCase: self)
    }
    
    func testCollectionRefresh() {
        let cell = BookListScreen.visibleBookCell()
        let screen = BookListScreen.screen
        
        let start = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 2.5))
        start.press(forDuration: 0, thenDragTo: finish)
        
        waitElementExists(element: cell, scrollElement: screen)
    }
}

