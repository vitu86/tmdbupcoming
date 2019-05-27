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
    private var dataSource:[Int] = []
    
    
    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadData()
        }
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure CollectionView
        movieCollection.delegate = self
        movieCollection.dataSource = self
    }
    
    private func loadData() {
        if self.dataSource.count > 10 {
            self.canLoadMore = false
        }
        var indexesToAdd:[IndexPath] = []
        for i in 0 ..< 2 {
            indexesToAdd.append(IndexPath(row: dataSource.count, section: 0))
            dataSource.append(i)
        }
        movieCollection.insertItems(at: indexesToAdd)
        if canLoadMore {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.loadData()
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
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer:UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MovieListFooter", for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("Perguntou tamanho: ", canLoadMore)
        return canLoadMore ? CGSize(width: 100, height: 100) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        // TODO: Load more data
        // FIXME: Teste
    }
}
