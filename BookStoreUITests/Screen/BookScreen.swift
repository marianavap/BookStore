//
//  BookScreen.swift
//  BookStoreUITests
//
//  Created by Smiles on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

class BookScreen: BaseScreen {
    static var screen: XCUIElement {
        return XCUIApplication().otherElements["BookScreen"]
    }
}
