//
//  BookStoreProvider.swift
//  AppStore
//
//  Created by Mariana on 28/06/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import Reachability

/// Image service
protocol BookStoreServiceProtocol {
    func getBookStore(startIndex: Int, completion: @escaping ((() throws -> (BookList)) -> Void))
}

class BookStoreProvider: BookStoreServiceProtocol {
    private let session: BookStoreURLSession
    private let reachability: BookStoreReachability
    
    init(session: BookStoreURLSession = URLSession.shared, reachability: BookStoreReachability = Reachability(hostName: Constants.WEBSERVICE_BASE_URL)) {
        self.session = session
        self.reachability = reachability
    }
    
    func getBookStore(startIndex: Int, completion: @escaping ((() throws -> (BookList)) -> Void)) {
        
        guard reachability.internetIsReachable else {
            completion { throw BookStoreError.offlineMode }
            return
        }
        
        guard let urlImage = completeUrl(startIndex: startIndex) else {
            completion { throw BookStoreError.generic }
            return
        }
        
        session.loadData(from:urlImage) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion { throw error }
            } else if let data = data {
                do {
                    let books = try JSONDecoder().decode(AllBooks.self, from: data)
                    
                    let bookList = BookList(books: books.items)
                    
                    completion { bookList }
                } catch {
                    completion { throw BookStoreError.parse(String(describing: Item.self)) }
                }
            }
        }
    }
    
}

private extension BookStoreProvider {
    func completeUrl(startIndex: Int) -> URL? {
        var urlComponents = URLComponents(string: Constants.WEBSERVICE_BASE_URL)
        urlComponents?.queryItems = [URLQueryItem(name: Constants.PLATFORM, value: Constants.IOS),
        URLQueryItem(name: Constants.MAXRESULT, value: Constants.VALUERESULT),
        URLQueryItem(name: Constants.STARTINDEX, value: "\(startIndex)")]
        return urlComponents?.url
    }
}
