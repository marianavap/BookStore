//
//  Webservice.swift
//  AppDefaultForTests
//
//  Created by Mariana on 28/06/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import Reachability

/// Image service
protocol ImageServiceProtocol {
    func getURLImage(startIndex: Int, completion: @escaping ((() throws -> (BookList)) -> Void))
}

class Webservice: ImageServiceProtocol {
    private let session: URLSession
    private let reachability: Reachability
    
    init(session: URLSession = URLSession.shared, reachability: Reachability = Reachability(hostName: Constants.WEBSERVICE_BASE_URL)) {
        self.session = session
        self.reachability = reachability
    }
    
    func getURLImage(startIndex: Int, completion: @escaping ((() throws -> (BookList)) -> Void)) {
        
        guard let urlImage = completeUrl(startIndex: startIndex) else {
            completion { throw AllError.generic }
            return
        }
        
        session.loadData(from:urlImage) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion { throw error }
            } else if let data = data {
                do {
                    let books = try JSONDecoder().decode(AllBooks.self, from: data)
                    
                    let imgList = BookList(books: books.items)
                    
                    completion { imgList }
                } catch {
                    completion { throw AllError.parse(String(describing: Item.self)) }
                }
            }
        }
    }
    
}

private extension Webservice {
    func completeUrl(startIndex: Int) -> URL? {
        var urlComponents = URLComponents(string: Constants.WEBSERVICE_BASE_URL)
        urlComponents?.queryItems = [URLQueryItem(name: Constants.PLATFORM, value: Constants.PLATFORM),
        URLQueryItem(name: Constants.MAXRESULT, value: Constants.VALUERESULT),
        URLQueryItem(name: Constants.STARTINDEX, value: "\(startIndex)")]
        return urlComponents?.url
    }
    
}
