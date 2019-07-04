//
//  BookDetailViewController.swift
//  BookStore
//
//  Created by Mariana on 02/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    struct Constants {
        static let unfavoriteimage: String = "unfavorite"
        static let favoriteimage : String =  "favorite"
    }
    
    @IBOutlet weak var favorite: UIButton? {
        didSet {
            let filtered = SectionCache.sharedInstance.favoriteBooks
            
            favorite?.isSelected = false
            favorite?.setImage(UIImage(imageLiteralResourceName : Constants.unfavoriteimage), for: .normal)
            
            if filtered.count != 0 {
                for (key, _) in filtered {
                    if key == bookViewModel.id {
                        favorite?.isSelected = true
                        favorite?.setImage(UIImage(imageLiteralResourceName : Constants.favoriteimage), for: .normal)
                    }
                }
            } else {
                favorite?.isSelected = false
                favorite?.setImage(UIImage(imageLiteralResourceName : Constants.unfavoriteimage), for: .normal)
            } 
        }
    }
    
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
    
    @IBAction func favoriteButton (sender: UIButton) {
        bookViewModel.allFavoriteBooks(book: bookViewModel)
        
        if favorite?.isSelected == false {
            favorite?.isSelected = true
            favorite?.setImage(UIImage(imageLiteralResourceName : Constants.favoriteimage), for: .normal)
        } else {
            favorite?.isSelected = false
            favorite?.setImage(UIImage(imageLiteralResourceName : Constants.unfavoriteimage), for: .normal)
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
