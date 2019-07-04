//
//  ProjectViewController.swift
//  AppDefaultForTests
//
//  Created by Mariana on 28/06/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import UIKit

class BookListCollectionViewController: UICollectionViewController {
    struct Constants {
        static let cellsPerRow: Int = 2
        static let loadingCellHeight: CGFloat = 50
        static let insets: CGFloat = 16
        static let margins: CGFloat = CGFloat(cellsPerRow + 1) * insets
        static let marginsLoading: CGFloat = 2 * insets
        static let cellImageMargins: CGFloat = 8.0 * 2.0
        static let cellUsedHeight: CGFloat = cellImageMargins + (4.0 * 2.0) + (3.0 * 20.5)
    }
    
    private var bookListViewModel = BookListViewModel()
    private var isFavorite : Bool = false
    
    @IBOutlet var clear: UIBarButtonItem?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .silver
        return refreshControl
    }()
}

// MARK: - Overrides
extension BookListCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bookListViewModel.delegate = self
//        self.clear?.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = nil
        
        collectionView?.refreshControl = refreshControl
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? BookCollectionViewCell,
            let controller = segue.destination as? BookDetailViewController {
            controller.setup(cell.bookViewModel)
        }
    }
}

// MARK: - Private methods
private extension BookListCollectionViewController {
    @objc private func refresh() {
        bookListViewModel.fetch(refresh: true)
    }
}

// MARK: - Delegate
extension BookListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if case .book = bookListViewModel.cellType(at: indexPath),
            let bookCell = cell as? BookCollectionViewCell {
            bookCell.bookImage?.kf.cancelDownloadTask()
        }
    }
}

// MARK: - Datasource
extension BookListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookListViewModel.numberOfItens(in: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = bookListViewModel.cellType(at: indexPath)
        switch cellType {
        case .book(let bookViewModel):
            let cell = collectionView.dequeueReusableCell(viewType: BookCollectionViewCell.self, for: indexPath)
            cell.setup(book: bookViewModel)
            return cell
        case .loading:
            let cell = collectionView.dequeueReusableCell(viewType: BookLoadingCollectionViewCell.self, for: indexPath)
          
            if isFavorite == false {
                bookListViewModel.fetch()
                cell.setup()
            } else {
                cell.noIndicator()
            }
            
            return cell
        }
    }
}


// MARK: - BookListViewModelDelegate
extension BookListCollectionViewController: BookListControllerDelegate {
    func bookListViewModel(_ viewModel: BookListViewModel, threw error: Error) {
         HandleError.handle(error: error)
    }
    
    func bookListViewModelWasFetch(_ viewModel: BookListViewModel) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - Flow layout
extension BookListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellType = bookListViewModel.cellType(at: indexPath)
        switch cellType {
        case .book:
            let width = (collectionView.frame.width - Constants.margins)/CGFloat(Constants.cellsPerRow)
            let imageSize: CGFloat = width - Constants.cellImageMargins
            let height: CGFloat = Constants.cellUsedHeight + imageSize
            return CGSize(width: width, height: height)
        case .loading:
            let width = (collectionView.frame.width - Constants.marginsLoading)
            return CGSize(width: width, height: Constants.loadingCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.insets, left: Constants.insets, bottom: Constants.insets, right: Constants.insets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.insets
    }

    @IBAction func seeAllFavorites () {
        isFavorite = true
        bookListViewModel.favoritesBooks()
        self.navigationItem.leftBarButtonItem = self.clear
        self.collectionView.reloadData()
    }
    
    func verifyFavoriteValues () {
        if isFavorite == true {
            bookListViewModel.favoritesBooks()
            self.collectionView.reloadData()
        }
       
    }
    
    @IBAction func clearFavorites () {
        isFavorite = false
        self.navigationItem.leftBarButtonItem = nil
        bookListViewModel.fetch(refresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        verifyFavoriteValues()
    }
}

