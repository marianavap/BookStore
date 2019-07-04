//
//  FlickrURLSession.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

protocol BookStoreURLSession {
    
    /// Load data from url
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completionHandler: Completion handler
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}
