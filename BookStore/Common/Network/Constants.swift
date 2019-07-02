//
//  Constants.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 30/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

struct Constants {
    static let WEBSERVICE_BASE_URL = "https://www.googleapis.com/books/v1/volumes?q=ios&maxResults=20&startIndex=0"
//    static let WEBSERVICE_BASE_URL = "https://api.flickr.com/services/rest/?"
    static let API_KEY = "f9cc014fa76b098f9e82f1c288379ea1"
    static let SEARCH = "flickr.photos.search"
    static let SIZES = "flickr.photos.getSizes"
    static let TAGS = "kitten"
    static let FORMAT = "json"
    static let JSONCALLBACK = "1"
    
    
    static let nojsoncallback = "nojsoncallback"
    static let format = "format"
    static let tags = "tags"
    static let apikey = "api_key"
    static let method = "method"
    static let page = "page"
    static let per_page = "per_page"
    static let search = "search"
    static let photo_id = "photo_id"
}

