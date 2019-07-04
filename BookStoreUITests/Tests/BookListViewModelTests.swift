//
//  BookListViewModelTests.swift
//  BookStoreUITests
//
//  Created by Smiles on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest
@testable import BookStore

class BookServiceMock: BookStoreServiceProtocol {
    typealias ParamsAssertionType = (Int) -> Void
    
    var bookList: BookList?
    private var error: Error?
    var paramsAssertion: ParamsAssertionType?
    
    init(bookList: BookList? = nil, error: Error? = nil, paramsAssertion: ParamsAssertionType? = nil) {
        self.bookList = bookList
        self.error = error
        self.paramsAssertion = paramsAssertion
    }
    
    func getBookStore(startIndex: Int, completion: @escaping ((() throws -> (BookList)) -> Void)) {
        paramsAssertion?(startIndex)
        
        if let error = error {
            completion { throw error }
        } else if let bookList = bookList {
            completion { bookList }
        }
    }
}

class BookListViewModelDelegateMock: BookListControllerDelegate {
    typealias ModelWasFetchAssertionType = (BookListViewModel) -> Void
    typealias ModelThrewErrorAssertionType = (BookListViewModel, Error) -> Void
    private var modelWasFetchAssertion: ModelWasFetchAssertionType?
    private var modelThrewErrorAssertion: ModelThrewErrorAssertionType?
    
    init(modelWasFetchAssertion: ModelWasFetchAssertionType? = nil,
         modelThrewErrorAssertion: ModelThrewErrorAssertionType? = nil) {
        self.modelWasFetchAssertion = modelWasFetchAssertion
        self.modelThrewErrorAssertion = modelThrewErrorAssertion
    }
  
    func bookListViewModelWasFetch(_ viewModel: BookListViewModel) {
        modelWasFetchAssertion?(viewModel)
        
    }
    
    func bookListViewModel(_ viewModel: BookListViewModel, threw error: Error) {
        modelThrewErrorAssertion?(viewModel, error)
    }
}

class BookListViewModelTests: BaseTests {
    func testSuccessfullFetch() {
        //Arrange
        let expectation = self.expectation(description: "Delegate was called")
        let book = Item(id: "KWuCCwAAQBAJ",
                        volumeInfo: VolumeInfo.init(title: "",
                                                    authors: [""],
                                                    volumeInfoDescription: "",
                                                    imageLinks: ImageLinks.init(smallThumbnail: "",
                                                                                thumbnail: "")), saleInfo: SaleInfo.init(buyLink: ""))
        let bookList = BookList(books: [book])
        let bookServiceMock = BookServiceMock(bookList: bookList)
        let vm = BookListViewModel(appService: bookServiceMock)
        let vmDelegate = BookListViewModelDelegateMock(modelWasFetchAssertion: { viewModel in
            expectation.fulfill()
            XCTAssertTrue(viewModel === vm)
        })
        vm.delegate = vmDelegate
        
        //Act
        vm.fetch()
        
        //Assert
        waitForExpectations(timeout: 1)
//        XCTAssertEqual(vm.beers.count, beerList.beers.count)
//        XCTAssertEqual(vm.beers.first?.id, beer.id)
//        XCTAssertEqual(vm.beers.first?.imageURL, beer.imageURL)
//        XCTAssertEqual(vm.beers.first?.name, beer.name)
//        XCTAssertEqual(vm.beers.first?.tagline, beer.tagline)
//        XCTAssertEqual(vm.beers.first?.abvString, "abv 20.0%")
//        XCTAssertEqual(vm.beers.first?.ibuString, "ibu 10.0")
//        XCTAssertEqual(vm.beers.first?.description, beer.description)
        
//        XCTAssertEqual(vm.id, book.id)
//        XCTAssertEqual(vm.smallThumbnail, book.volumeInfo.imageLinks.smallThumbnail)
//        XCTAssertEqual(vm.title, book.volumeInfo.title)
//        XCTAssertEqual(vm.volumeInfoDescription, book.volumeInfo.volumeInfoDescription)
//        XCTAssertEqual(vm.thumbnail, book.volumeInfo.imageLinks.thumbnail)
//        XCTAssertEqual(vm.buyLink, book.saleInfo.buyLink)
    }
    
    func testErrorFetch() {
        //Arrange
        let expectation = self.expectation(description: "Delegate was called")
        let bookServiceMock = BookServiceMock(error: BookStoreError.generic)
        let vm = BookListViewModel(appService: bookServiceMock)
        let vmDelegate = BookListViewModelDelegateMock(modelThrewErrorAssertion: { viewModel, error in
            expectation.fulfill()
            XCTAssertTrue(viewModel === vm)
            guard case BookStoreError.generic = error else {
                XCTFail("Wrong error type")
                return
            }
        })
        vm.delegate = vmDelegate
        
        //Act
        vm.fetch()
        
        //Assert
        waitForExpectations(timeout: 1)
    }
    
    func testFetchParams() {
        //First page
        
        //Arrange
        var expectation = self.expectation(description: "Params first page assertion")
        let bookList = BookList(books: [Item])
        let bookServiceMock = BookServiceMock(bookList: bookList) { (startIndex) in
            expectation.fulfill()
            XCTAssertEqual(page, 1)
            XCTAssertEqual(perPage, 8)
        }
        let vm = BookListViewModel(bookService: bookServiceMock)
        
        //Act
        vm.fetch()
        
        //Assert
        waitForExpectations(timeout: 1)
        
        
        
        //Second page
        
        //Arrange
        expectation = self.expectation(description: "Params second page assertion")
        bookServiceMock.paramsAssertion = { (startIndex) in
            expectation.fulfill()
            XCTAssertEqual(page, 2)
            XCTAssertEqual(perPage, 8)
        }
        
        //Act
        vm.fetch()
        
        //Assert
        waitForExpectations(timeout: 1)
        
        
        //Refresh
        
        //Arrange
        expectation = self.expectation(description: "Params refresh assertion")
        bookServiceMock.paramsAssertion = { (startIndex) in
            expectation.fulfill()
            XCTAssertEqual(page, 1)
            XCTAssertEqual(perPage, 8)
        }
        
        //Act
        vm.fetch(refresh: true)
        
        //Assert
        waitForExpectations(timeout: 1)
    }
    
    func testCellsTypeWithLoading() {
        //Arrange
        let book = Item(id: "KWuCCwAAQBAJ",
                        volumeInfo: VolumeInfo.init(title: "",
                                                    authors: [""],
                                                    volumeInfoDescription: "",
                                                    imageLinks: ImageLinks.init(smallThumbnail: "",
                                                                                thumbnail: "")), saleInfo: SaleInfo.init(buyLink: ""))
        let bookList = BookList(books: [book])
        let bookServiceMock = BookServiceMock(bookList: bookList)
        let vm = BookListViewModel(appService: bookServiceMock)

        //Act
        vm.fetch()
        
        //Assert
        XCTAssertEqual(vm.numberOfItens(in: 0), 2)
        if case let BookListViewModel.CellType.book(bvm) = vm.cellType(at: IndexPath(row: 0, section: 0)),
            case BookListViewModel.CellType.loading = vm.cellType(at: IndexPath(row: 1, section: 0)) {
            XCTAssertEqual(bvm.id, vm.books.first?.id)
        } else {
            XCTFail("Wrong cell type at index")
        }
    }
    
    func testCellsTypeWithoutLoading() {
        //Arrange
        let book = Item(id: "KWuCCwAAQBAJ",
                        volumeInfo: VolumeInfo.init(title: "",
                                                    authors: [""],
                                                    volumeInfoDescription: "",
                                                    imageLinks: ImageLinks.init(smallThumbnail: "",
                                                                                thumbnail: "")), saleInfo: SaleInfo.init(buyLink: ""))
        let bookListFirstPage = BookList(books: [book])
        let bookListSecondPage = BookList(books: [])
        let bookServiceMock = BookServiceMock(bookList: bookListFirstPage)
        let vm = BookListViewModel(appService: bookServiceMock)

        //Act
        vm.fetch()
        bookServiceMock.bookList = bookListSecondPage
        vm.fetch()
        
        //Assert
        XCTAssertEqual(vm.numberOfItens(in: 0), 1)
        if case let BookListViewModel.CellType.book(bvm) = vm.cellType(at: IndexPath(row: 0, section: 0)) {
            XCTAssertEqual(bvm.id, vm.books.first?.id)
        } else {
            XCTFail("Wrong cell type at index")
        }
    }
    
    func testCellsRefresh() {
        //Arrange
        let book = Item(id: "KWuCCwAAQBAJ",
                        volumeInfo: VolumeInfo.init(title: "",
                                                    authors: [""],
                                                    volumeInfoDescription: "",
                                                    imageLinks: ImageLinks.init(smallThumbnail: "",
                                                                                thumbnail: "")), saleInfo: SaleInfo.init(buyLink: ""))
        
        let bookListBeforeRefresh = BookList(books: [book])
        let bookListAfterRefresh = BookList(books: [])
        let bookServiceMock = BookServiceMock(bookList: bookListBeforeRefresh)
        let vm = BookListViewModel(appService: bookServiceMock)

        //Act
        vm.fetch()
        bookServiceMock.bookList = bookListAfterRefresh
        vm.fetch(refresh: true)
        
        //Assert
        XCTAssertEqual(vm.numberOfItens(in: 0), 0)
    }
}
