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
    func getURLImage(page: Int, perPage: Int, completion: @escaping ((() throws -> (BookList)) -> Void))
}

class Webservice: ImageServiceProtocol {
    private let session: URLSession
    private let reachability: Reachability
    
    init(session: URLSession = URLSession.shared, reachability: Reachability = Reachability(hostName: Constants.WEBSERVICE_BASE_URL)) {
        self.session = session
        self.reachability = reachability
    }
    
    func getURLImage(page: Int, perPage: Int, completion: @escaping ((() throws -> (BookList)) -> Void)) {
        
        guard let urlImage = completeUrl(method: Constants.SIZES, page: 0, perpage: 0) else {
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
    func completeUrl(method: String, page: Int, perpage: Int) -> URL? {
        let urlComponents = URLComponents(string: Constants.WEBSERVICE_BASE_URL)
//        urlComponents?.queryItems = [
//            URLQueryItem(name: Constants.nojsoncallback, value: "\(Constants.JSONCALLBACK)"),
//            URLQueryItem(name: Constants.format, value: "\(Constants.FORMAT)"),
//            URLQueryItem(name: Constants.tags, value: "\(Constants.TAGS)"),
//            URLQueryItem(name: Constants.apikey, value: "\(Constants.API_KEY)"),
//            URLQueryItem(name: Constants.method, value: "\(method)"),
//            URLQueryItem(name: Constants.page, value: "\(page)"),
//            URLQueryItem(name: Constants.per_page, value: "\(perpage)")]
        
        return urlComponents?.url
    }
    
}
