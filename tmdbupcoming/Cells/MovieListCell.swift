//
//  MovieListCell.swift
//  tmdbupcoming
//
//  Created by Vitor Costa on 26/05/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit
import MaterialComponents
import AlamofireImage

class MovieListeCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var card: MDCCard!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // Override Function
    override func awakeFromNib() {
        super.awakeFromNib()
        card.setShadowElevation(.cardPickedUp, for: .normal)
    }
    
    // Public Function
    func setupCell(with movie: Movie) {
        if let imageURL = URL(string: movie.thumbnailImage)  {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "IconPlaceholderImage"), filter: nil, progress: nil, progressQueue: .main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: nil)
        } else {
            posterImageView.contentMode = .scaleAspectFit
            posterImageView.image = #imageLiteral(resourceName: "IconNoImage")
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
    }
}
