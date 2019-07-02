//
//  Identifiable.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import UIKit

protocol Identifiable: class {
}

// MARK: - Identifiable Extension on UIView
extension Identifiable where Self: UIView {
    
    /// Reuse identifier used in storyboards
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
