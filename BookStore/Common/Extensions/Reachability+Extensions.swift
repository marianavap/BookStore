//
//  Reachability+Extensions.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//


import Reachability

// MARK: - ImageReachability
extension Reachability: ProjectReachability {
    
    /// True if internet is reachable
    var internetIsReachable: Bool {
        return isReachable()
    }
}
