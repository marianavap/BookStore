//
//  SectionCache.swift
//  BookStore
//
//  Created by Smiles on 03/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

class SectionCache: NSObject {
    static let sharedInstance = SectionCache()
    
//    var books: [BookViewModel] = []
    
    var favoriteBooks:[String:BookViewModel] = [:]

}
