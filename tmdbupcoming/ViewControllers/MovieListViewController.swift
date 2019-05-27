//
//  MovieListViewController.swift
//  tmdbupcoming
//
//  Created by Vitor Costa on 26/05/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieCollection: UICollectionView!
    
    // MARK: - Internal Properties (visible to extensions)
    internal var canLoadMore: Bool = true
    internal var dataSource: [Movie] = []
    internal var searchBar: UISearchBar = UISearchBar()
    
    // MARK: - Private Properties
    private var searchButton: UIBarButtonItem!
    
    
    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToMovieDetail" {
            let vc = segue.destination as! MovieDetailViewController
            vc.movie = (sender as! Movie)
        }
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure CollectionView
        movieCollection.delegate = self
        movieCollection.dataSource = self
        
        // ConfigureSearchBar
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        
        hideSearchBar()
    }
    
    // MARK: - Internal Functions (visible to extensions)
    internal func loadData() {
        if canLoadMore {
            NetworkHelper.sharedInstance.getNextMovieList { (movies) in
                if movies.isEmpty {
                    self.canLoadMore = false
                }
                var indexesToReload: [IndexPath] = []
                for item in movies {
                    indexesToReload.append(IndexPath(row: self.dataSource.count, section: 0))
                    self.dataSource.append(item)
                }
                self.movieCollection.insertItems(at: indexesToReload)
            }
        }
    }
    
    internal func search(text: String) {
        // TODO: Search Movie
    }
    
    internal func hideSearchBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.alpha = 0
        }, completion: { finished in
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItems = [self.searchButton]
            self.title = "TMDB Upcoming"
        })
    }
    
    // MARK: - Private Functions
    @objc private func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems = []
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
}
