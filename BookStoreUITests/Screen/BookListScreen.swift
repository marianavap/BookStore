//
//  BookListScreen.swift
//  BookStoreUITests
//
//  Created by Mariana V. A. Souza on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

class BookListScreen: BaseScreen {
    private struct ElementsIds {
        static let visibleBookLoadText = "ImageCell"
        static let notVisibleBookLoadText = "X"
    }
    
    static var screen: XCUIElement {
        return XCUIApplication().collectionViews["BookListScreen"]
    }
    
    static func visibleBookCell() -> XCUIElement {
        return screen.cells.containing(.image, identifier: ElementsIds.visibleBookLoadText).firstMatch
    }
    
    static func notVisibleBookCell() -> XCUIElement {
        return screen.cells.containing(.image, identifier: ElementsIds.notVisibleBookLoadText).firstMatch
    }
}
