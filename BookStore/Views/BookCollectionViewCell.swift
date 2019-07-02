//
//  ImageViewCell.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 30/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        layer.cornerRadius = 4
        layer.masksToBounds = false
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerImage.kf.cancelDownloadTask()
    }
}

// MARK: - Auxiliar methods
extension BookCollectionViewCell {
    func setup(book: BookViewModel) {
        bannerImage.setImage(with: book.smallThumbnail)
    }
}

// MARK: - Identifiable
extension BookCollectionViewCell: Identifiable {}
