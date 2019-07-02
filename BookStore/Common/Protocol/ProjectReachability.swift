//
//  FlickrReachability.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

protocol ProjectReachability {
    
    /// True if internet is available
    var internetIsReachable: Bool { get }
}
