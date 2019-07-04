//
//  BookServiceTests.swift
//  BookStoreTests
//
//  Created by Mariana V. A. Souza on 04/07/19.
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
        XCTAssertEqual(bookList.books.first?.volumeInfo.title, "iOS")
        XCTAssertEqual(bookList.books.first?.volumeInfo.authors?[0], "Rafael Steil")
        XCTAssertEqual(bookList.books.first?.volumeInfo.volumeInfoDescription, "Uma grande parcela do mercado de celulares e tablets atualmente pertence à Apple, com seus famosos iPhone e iPad. Aprenda a criar aplicações que explorem o máximo da poderosa plataforma sobre a qual esses dispositivos funcionam, o iOS. Aprenda o Objective-C de forma descomplicada e comece em poucas horas a criar suas aplicações e testá-las em seus dispositivos e nos emuladores. Nessa nova versão, completamente revisada, há 100% de compatibilidade com Xcode 5 e iOS 7, um novo capítulo sobre storyboards, todas as imagens com o layout do iOS 7 e exemplos revisados e aprimorados.")
        XCTAssertEqual(bookList.books.first?.volumeInfo.imageLinks.smallThumbnail, "http://books.google.com/books/content?id=KWuCCwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api")
        XCTAssertEqual(bookList.books.first?.volumeInfo.imageLinks.thumbnail, "http://books.google.com/books/content?id=KWuCCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")
        XCTAssertEqual(bookList.books.first?.saleInfo.buyLink, "https://play.google.com/store/books/details?id=KWuCCwAAQBAJ&rdid=book-KWuCCwAAQBAJ&rdot=1&source=gbs_api")
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
