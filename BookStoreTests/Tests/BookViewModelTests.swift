//
//  BookViewModelTests.swift
//  BookStoreTests
//
//  Created by Smiles on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest
@testable import BookStore

class BookViewModelTests: BaseTests {
    
    func testViewModelInit() {
        //Arrange

        let book = Item(id: "KWuCCwAAQBAJ",
                        volumeInfo: VolumeInfo.init(title: "title",
                                                    authors: ["authors"],
                                                    volumeInfoDescription: "description",
                                                    imageLinks: ImageLinks.init(smallThumbnail: "smallThumbnail",
                                                                                thumbnail: "thumbnail")), saleInfo: SaleInfo.init(buyLink: "buyLink"))
        
        //Act
        let vm = BookViewModel(book)
        
        //Assert
        XCTAssertEqual(vm.id, book.id)
        XCTAssertEqual(vm.smallThumbnail, book.volumeInfo.imageLinks.smallThumbnail)
        XCTAssertEqual(vm.title, book.volumeInfo.title)
        XCTAssertEqual(vm.volumeInfoDescription, book.volumeInfo.volumeInfoDescription)
        XCTAssertEqual(vm.thumbnail, book.volumeInfo.imageLinks.thumbnail)
        XCTAssertEqual(vm.buyLink, book.saleInfo.buyLink)
    }
}
