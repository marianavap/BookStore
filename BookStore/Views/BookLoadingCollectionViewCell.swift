//
//  BookLoadingCollectionViewCell.swift
//  BookStore
//
//  Created by Mariana V. A. Souza on 31/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import UIKit

class BookLoadingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
}

// MARK: - Auxiliar methods
extension BookLoadingCollectionViewCell {
    func setup() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .silver
    }
   
    func noIndicator () {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
}

// MARK: - Identifiable
extension BookLoadingCollectionViewCell: Identifiable {}
