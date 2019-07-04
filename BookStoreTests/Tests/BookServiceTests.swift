//
//  BookServiceTests.swift
//  BookStoreTests
//
//  Created by Smiles on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

@testable import BookStore

class URLSessionMock: BaseMock, BookStoreURLSession {
    var urlAssertBlock: ((URL?) -> Void)?
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        urlAssertBlock?(url)
        do {
            let data = try loadResponse()
            completionHandler(data, nil, nil)
        } catch {
            completionHandler(nil, nil, error)
        }
    }
}

class BookServiceTests: BaseTests {
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testNotReachable() {
        //Arrange
        let urlSessionMock = URLSessionMock.init()
        let expectation = self.expectation(description: "Expect generic error")
        
        let service = BookStoreProvider(session: urlSessionMock, reachability: ReachabilityMock(reachable: false))
        
        //Act
        service.getBookStore(startIndex: 0) { callback in
            do {
                _ = try callback()
            } catch BookStoreError.offlineMode {
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        waitForExpectations(timeout: 1)
    }
    
    func testApiError() {
        //Arrange
        let urlSessionMock = URLSessionMock.init(file: "Book", error: BookStoreError.generic)
        let expectation = self.expectation(description: "Expect generic error")
        
        let service = BookStoreProvider(session: urlSessionMock, reachability: ReachabilityMock())
        
        //Act
        service.getBookStore(startIndex: 0) { callback in
            do {
                _ = try callback()
            } catch BookStoreError.generic {
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        waitForExpectations(timeout: 1)
    }
    
    func testParseError() {
        //Arrange
        let urlSessionMock = URLSessionMock.init(file: "BookParseError")
        let expectation = self.expectation(description: "Expect parse error")
        
        let service = BookStoreProvider(session: urlSessionMock, reachability: ReachabilityMock())
        
        //Act
        service.getBookStore(startIndex: 0) { callback in
            do {
                _ = try callback()
            } catch BookStoreError.parse {
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        waitForExpectations(timeout: 1)
    }
    
    func testSuccess() {
        //Arrange
        let urlSessionMock = URLSessionMock.init(file: "Book")
        let expectation = self.expectation(description: "Expect success")
        
        let service = BookStoreProvider(session: urlSessionMock, reachability: ReachabilityMock())
        var bookList: BookList!
        //Act
        service.getBookStore(startIndex: 1) { callback in
            do {
                bookList = try callback()
                
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        waitForExpectations(timeout: 1)
        XCTAssertEqual(bookList.books.count, 20)
        XCTAssertEqual(bookList.books[0].id, "KWuCCwAAQBAJ")
        
        
        
//        XCTAssertEqual(beerList.beers.count, 1)
//        XCTAssertEqual(beerList.beers[0].id, 1)
//        XCTAssertEqual(beerList.beers[0].imageURL, "https://images.punkapi.com/v2/keg.png")
//        XCTAssertEqual(beerList.beers[0].name, "Buzz")
//        XCTAssertEqual(beerList.beers[0].tagline, "A Real Bitter Experience.")
//        XCTAssertEqual(beerList.beers[0].alcoholByVolume, 4.5)
//        XCTAssertEqual(beerList.beers[0].internationalBitternessUnits, 60.0)
//        XCTAssertEqual(beerList.beers[0].description, "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.")
    }
    
    func testGeneratedURL() {
        //Arrange
        let expectation = self.expectation(description: "URL assertion")
        let urlSessionMock = URLSessionMock.init(file: "Book", error: BookStoreError.offlineMode)
        urlSessionMock.urlAssertBlock = {url in
            expectation.fulfill()
            XCTAssertEqual(url!.absoluteString, "https://www.googleapis.com/books/v1/volumes?q=ios&maxResults=20&startIndex=0")
        }
        
        let service = BookStoreProvider(session: urlSessionMock, reachability: ReachabilityMock())
        
        //Act
        service.getBookStore(startIndex: 0) { _ in }
        
        //Assert
        waitForExpectations(timeout: 1)
    }
}
