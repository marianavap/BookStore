//
//  AppViewModel.swift
//  AppDefaultForTests
//
//  Created by Mariana on 28/06/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

/// Delegate to comunicate with controller
protocol BookListControllerDelegate: class {
    /// Called when the list is updated
    ///
    /// - Parameter viewModel: ListViewModel
    func bookListViewModelWasFetch(_ viewModel: BookListViewModel)
    
    /// Called when some error happen
    ///
    /// - Parameters:
    ///   - viewModel: ListViewModel
    ///   - error: Error
    func bookListViewModel(_ viewModel: BookListViewModel, threw error: Error)
}

class BookListViewModel {
    weak var delegate: BookListControllerDelegate?
    
    private(set) var books: [BookViewModel] = []
    
    private var startIndex: Int = 0
    private var service: ImageServiceProtocol
    private var fetchCompleted = false
    private var isFetching = false
    private var error = false
    
    init(appService: ImageServiceProtocol = Webservice()) {
        self.service = appService
    }
}

// MARK: - Private
private extension BookListViewModel {
    
    func refresh() {
        startIndex = 0
        fetchCompleted = false
    }
}

extension BookListViewModel {
    /// Possible cell types
    ///
    /// - image: book cell
    /// - loading: loading cell
    enum CellType {
        case book(BookViewModel)
        case loading
    }
    
    /// Number of items in section
    ///
    /// - Parameter section: section
    /// - Returns: number of itens
    func numberOfItens(in section: Int) -> Int {
        let addLoadingCell = fetchCompleted || error ? 0 : 1
        return books.count + addLoadingCell
    }
    
    /// Cell type at index path
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: Cell type
    func cellType(at indexPath: IndexPath) -> CellType {
        if indexPath.row > books.count - 1 {
            return .loading
        }
        
        return .book(books[indexPath.row])
    }
    
    //Update values to show only favorite books
    func favoritesBooks() {
        
//        books.append(contentsOf: bookList.books.map({ (book) -> BookViewModel in
//            BookViewModel(book)
//        }))
//        books = SectionCache.sharedInstance.favoriteBooks.values

        let filteredBooks = SectionCache.sharedInstance.favoriteBooks
    
        var favorite: [BookViewModel] = []
        for (_, value) in filteredBooks {
            favorite.append(value)
        }
        
        books = favorite
    }
    
    /// Fetches book list
    ///
    /// - Parameter refresh: True if screen is being refreshed
    func fetch(refresh: Bool = false) {
        guard (!fetchCompleted && !isFetching) || !isFetching else {
            return
        }
        
        if refresh {
            self.refresh()
        }
        
        error = false
        startIndex += 1
        isFetching = true
        
        service.getURLImage(startIndex: startIndex) { [weak self] (callback) in
            guard let weakSelf = self else { return }
            do {
                let bookList = try callback()
                
                if refresh {
                    weakSelf.books = []
                }
                if bookList.books.isEmpty {
                    weakSelf.fetchCompleted = true
                } else {
                    weakSelf.books.append(contentsOf: bookList.books.map({ (book) -> BookViewModel in
                        BookViewModel(book)
                    }))
                }
                
                weakSelf.delegate?.bookListViewModelWasFetch(weakSelf)
            } catch {
                weakSelf.delegate?.bookListViewModel(weakSelf, threw: error)
                weakSelf.error = true
                weakSelf.startIndex -= 1
                weakSelf.delegate?.bookListViewModelWasFetch(weakSelf)
            }
            weakSelf.isFetching = false
        }
    }
}
