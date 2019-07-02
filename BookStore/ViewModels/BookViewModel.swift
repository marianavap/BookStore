//
//  BookViewModel.swift
//  BookStore
//
//  Created by Mariana on 02/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

struct BookViewModel {
    private(set) var smallThumbnail: String = String()
    private(set) var thumbnail: String = String()
    private(set) var title: String = String()
    private(set) var authors: [String]
    private(set) var volumeInfoDescription: String = String()
    private(set) var buyLink: String = String()
    
}

extension BookViewModel {
    init(_ book: Item) {
        smallThumbnail = book.volumeInfo.imageLinks.smallThumbnail ?? String()
        thumbnail = book.volumeInfo.imageLinks.thumbnail ?? String()
        title = book.volumeInfo.title ?? String()
        authors = (book.volumeInfo.authors) ?? [String()]
        volumeInfoDescription = book.volumeInfo.volumeInfoDescription ?? String()
        buyLink = book.saleInfo.buyLink ?? String()
    }
}
