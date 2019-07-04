//
//  URLSession+Extensions.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//


import Foundation

// MARK: - FlickrURLSession
extension URLSession: BookStoreURLSession {
    
    /// Data task to load
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completionHandler: completionHandler
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, urlResponse, error)
            }.resume()
    }
}
