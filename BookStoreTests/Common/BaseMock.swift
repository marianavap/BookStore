//
//  BaseMock.swift
//  BookStoreTests
//
//  Created by Smiles on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

class BaseMock {
    
    var file: String
    var error: Error?
    
    /// BaseMock Initializer
    ///
    /// - Parameters:
    ///   - file: file path
    ///   - error: error
    init(file: String = String(), error: Error? = nil) {
        self.file = file
        self.error = error
    }
    
    /// Base response Mock used in Mock protocols
    ///
    /// - Returns: Optional Data
    /// - Throws: Error
    func loadResponse() throws -> Data? {
        if let error = error {
            throw error
        }
        
        return try json()
    }
    
    /// Load json from file
    ///
    /// - Returns: Data
    /// - Throws: Error
    func json() throws -> Data {
        if let path = Bundle(for: BaseMock.self).path(forResource: file, ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return data
        }
        fatalError("File \"\(file)\" not found in bundle \"\(Bundle.main)\"")
    }
}
