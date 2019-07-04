//
//  BookListScreen.swift
//  BookStoreUITests
//
//  Created by Smiles on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

class BookListScreen: BaseScreen {
    private struct ElementsIds {
        static let visibleBookLoadText = "BookStore"
        static let notVisibleBookLoadText = "X"
    }
    
    static var screen: XCUIElement {
        return XCUIApplication().collectionViews["BookListScreen"]
    }
    
    static func visibleBookCell() -> XCUIElement {
        return screen.cells.containing(.staticText, identifier: ElementsIds.visibleBookLoadText).firstMatch
    }
    
    static func notVisibleBookCell() -> XCUIElement {
        return screen.cells.containing(.staticText, identifier: ElementsIds.notVisibleBookLoadText).firstMatch
    }
}
