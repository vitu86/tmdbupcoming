//
//  MovieDetailViewController.swift
//  tmdbupcoming
//
//  Created by Vitor Costa on 26/05/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    // MARK: - Public Properties (Data Injection)
    var movie: Movie!
    
    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        if let imageURL = URL(string: movie.originalImage)  {
            posterImageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "IconPlaceholderImage"), filter: nil, progress: nil, progressQueue: .main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: nil)
        } else {
            posterImageViewHeightConstraint.constant = 0
        }
        
        if let name = movie.title {
            nameLabel.text = name
        } else {
            nameLabel.text = "No name provided"
        }
        
        if !movie.genreList.isEmpty {
            genreLabel.text = movie.genreList.map({ (item) -> String in
                return item.name ?? "-"
            }).joined(separator: ", ")
        } else {
            genreLabel.text = "No genre provided"
        }
        
        if let releaseDate = movie.releaseDate {
            releaseDateLabel.text = releaseDate
        } else {
            releaseDateLabel.text = "No release date provided"
        }
        
        if let overview = movie.overview {
            overviewLabel.text = overview
        } else {
            overviewLabel.text = "No overview provided"
        }
    }
    
}
