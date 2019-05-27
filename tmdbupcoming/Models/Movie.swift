//
//  Movie.swift
//  tmdbupcoming
//
//  Created by Vitor Costa on 26/05/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import ObjectMapper

class Movie: Mappable {
    
    // Properties loaded form web
    var id: Int?
    var title: String?
    var posterPath: String?
    var genreIds: [Int]?
    var backdropPath: String?
    var overview: String?
    var releaseDate: String?
    
    // Properties built real time
    var genreList: [Genre] = []
    var thumbnailImage: String = ""
    var originalImage: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        posterPath <- map["poster_path"]
        genreIds <- map["genre_ids"]
        backdropPath <- map["backdrop_path"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
    }
}
