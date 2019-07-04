//
//  Errors.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

/// Possible errors
///
/// - httpError: Http response error
/// - generic: Unknown error
/// - parse: parse error
/// - offlineMode: user is offline
enum BookStoreError: Error {
    case httpError(Int)
    case generic
    case parse(String)
    case offlineMode
}
