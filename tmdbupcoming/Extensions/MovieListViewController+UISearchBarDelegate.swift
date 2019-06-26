//
//  MovieListViewController+UISearchBarDelegate.swift
//  tmdbupcoming
//
//  Created by Vitor Costa on 27/05/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit

extension MovieListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        hideSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text {
            searchBar.resignFirstResponder()
            hideSearchBar()
            search(text: searchString)
        }
    }
}
