//
//  ReachabilityMock.swift
//  BookStoreTests
//
//  Created by Smiles on 04/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

@testable import BookStore

class ReachabilityMock: BookStoreReachability {
    private var reachable: Bool
    
    init(reachable: Bool = true) {
        self.reachable = reachable
    }
    
    var internetIsReachable: Bool {
        return reachable
    }
}
