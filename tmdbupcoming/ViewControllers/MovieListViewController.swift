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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    // MARK: - Private Properties
    private var canLoadMore:Bool = true
    private var dataSource:[Movie] = []
    
    
    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure CollectionView
        movieCollection.delegate = self
        movieCollection.dataSource = self
    }
    
    private func loadData() {
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
}

// MARK: - UICollectionview Functions
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieListeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as! MovieListeCell
        let item = dataSource[indexPath.item]
        
        cell.setupCell(with: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer:UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MovieListFooter", for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return canLoadMore ? CGSize(width: 100, height: 100) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        self.loadData()
    }
}
