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
    internal var isFooterShowing: Bool = false
    internal var dataSource: [Movie] = []
    internal var searchBar: UISearchBar = UISearchBar()
    
    // MARK: - Private Properties
    private var searchButton: UIBarButtonItem!
    private var refreshButton: UIBarButtonItem!
    private var filterString: String = ""
    private var needReset: Bool = false
    
    
    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        
        // Configure Navigation Itens
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshMovieList))
        hideSearchBar()
    }
    
    // MARK: - Internal Functions (visible to extensions)
    internal func loadData() {
        if canLoadMore {
            NetworkHelper.shared.getNextMovieList(with: filterString, needReset) { (movies, error) in
                
                if error {
                    self.filterString = "Error"
                    self.hideSearchBar()
                    self.showAlert(title: "Attention", message: "Could not load movies. Check your connectin and click on refresh button!")
                }
                
                self.needReset = false
                
                guard let movies = movies else {
                    self.canLoadMore = false
                    self.movieCollection.collectionViewLayout.invalidateLayout()
                    return
                }
                
                var indexesToReload: [IndexPath] = []
                for item in movies {
                    indexesToReload.append(IndexPath(row: self.dataSource.count, section: 0))
                    self.dataSource.append(item)
                }
                
                self.movieCollection.performBatchUpdates({
                    self.movieCollection.insertItems(at: indexesToReload)
                }, completion: { (_) in
                    if self.isFooterShowing {
                        // If number of movies doesn't fill screen, load more until fill or the list is over.
                        self.loadData()
                    }
                })
                
            }
        }
    }
    
    internal func search(text: String) {
        filterString = text
        resetData()
    }
    
    internal func hideSearchBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.alpha = 0
        }, completion: { finished in
            self.navigationItem.titleView = nil
            if self.filterString.isEmpty {
                self.title = "TMDB Upcoming"
                self.navigationItem.rightBarButtonItems = [self.searchButton]
            } else {
                self.title = "TMDB Upcoming - \"\(self.filterString)\""
                self.navigationItem.rightBarButtonItems = [self.refreshButton, self.searchButton]
            }
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
    
    @objc private func refreshMovieList() {
        filterString = ""
        searchBar.text = ""
        hideSearchBar()
        resetData()
    }
    
    private func resetData() {
        dataSource = []    
        canLoadMore = true
        needReset = true
        movieCollection.reloadData()
    }
}
