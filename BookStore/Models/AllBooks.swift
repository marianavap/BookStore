//
//  ValuesURL.swift
//  AppDefaultForTests
//
//  Created by Mariana on 28/06/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

//struct ValuesURL: Codable {
//    var getItems: [Item] = []
//}

// MARK: - Welcome
struct AllBooks: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: String?
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let buyLink: String?
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let volumeInfoDescription: String?
    let imageLinks: ImageLinks

    enum CodingKeys: String, CodingKey {
        case title, authors
        case imageLinks
        case volumeInfoDescription = "description"
    }
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}

