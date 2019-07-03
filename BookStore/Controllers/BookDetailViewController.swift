//
//  BookDetailViewController.swift
//  BookStore
//
//  Created by Mariana on 02/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    @IBOutlet weak var bookImageView: UIImageView! {
        didSet {
            bookImageView.setImage(with: bookViewModel.thumbnail)
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = bookViewModel.title
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
//            descriptionLabel.sizeToFit()
//            descriptionLabel.adjustsFontSizeToFitWidth = true
//            descriptionLabel.frame.size.height = descriptionLabel.optimalHeight
          
            descriptionLabel.text = bookViewModel.volumeInfoDescription
        }
    }
    @IBOutlet weak var authorLabel: UILabel! {
        didSet {
            let authors = bookViewModel.authors.joined(separator: ", ")
            authorLabel.text = authors
        }
    }
    @IBOutlet weak var buyLinkLabel: UITextView! {
        didSet {
            buyLinkLabel.isEditable = false
            buyLinkLabel.dataDetectorTypes = .link
            buyLinkLabel.text = bookViewModel.buyLink
        }
    }
 
    private var bookViewModel: BookViewModel!
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        bookImageView?.kf.cancelDownloadTask()
    }
}

// MARK: - Auxiliar methods
extension BookDetailViewController {
    func setup(_ viewModel: BookViewModel) {
        bookViewModel = viewModel
    }
}


