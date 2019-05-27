//
//  NetworkHelper.swift
//  tmdbupcoming
//
//  Created by Vitor Costa on 26/05/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class NetworkHelper {
    
    // MARK: Singleton References
    // STATIC OBJECT REFERENCE
    static let sharedInstance:NetworkHelper = NetworkHelper()
    // Private init for override purpose
    private init() {
    }
    
    // MARK: - Private Properties
    private var genresList:[Genre] = []
    private var currentMovieListPage: Int = 1
    
    // MARK: - Private Constants
    private let TMDB_API_KEY: String = "1f54bd990f1cdfb230adb312546d765d"
    private let TMDB_GENRES_URL: String = "https://api.themoviedb.org/3/genre/movie/list"
    private let TMDB_MOVIES_URL: String = "https://api.themoviedb.org/3/movie/upcoming"
    private let TMDB_IMAGES_BASE_URL: String = "https://image.tmdb.org/t/p"
    
    // MARK: - Public Functions
    func getNextMovieList(onComplete:@escaping ([Movie]) -> ()) {
        if genresList.isEmpty{
            loadGenres { (result) in
                if result {
                    self.loadMovies(onComplete: onComplete)
                } else {
                    onComplete([])
                }
            }
        } else {
            loadMovies(onComplete: onComplete)
        }
    }
    
    //MARK: - Private Functions
    private func loadGenres(onComplete: @escaping (Bool) -> ()) {
        let params: Parameters = ["api_key": TMDB_API_KEY]
        Alamofire.request(TMDB_GENRES_URL, method: .get, parameters: params).responseArray(keyPath: "genres") { (response: DataResponse<[Genre]>) in
            if let genres = response.result.value {
                self.genresList = genres
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
    }
    
    private func getGenres(with ids: [Int]) -> [Genre] {
        return genresList.filter({ (item) -> Bool in
            if let itemId = item.id {
                if ids.contains(itemId) {
                    return true
                }
            }
            return false
        })
    }
    
    private func loadMovies(onComplete:@escaping ([Movie]) -> ()) {
        let params: Parameters = ["api_key": TMDB_API_KEY, "page": currentMovieListPage]
        Alamofire.request(TMDB_MOVIES_URL, method: .get, parameters: params).responseArray(keyPath: "results") { (response: DataResponse<[Movie]>) in
            if let movieList = response.result.value {
                self.currentMovieListPage = self.currentMovieListPage + 1
                onComplete(movieList.map({ (item) -> Movie in
                    // Fill genre list
                    if let genreIds = item.genreIds {
                        item.genreList = self.getGenres(with: genreIds)
                    }
                    
                    // Fill images URLs
                    if let posterImage = item.posterPath {
                        item.thumbnailImage = self.TMDB_IMAGES_BASE_URL + "/w185/" + posterImage
                        item.originalImage = self.TMDB_IMAGES_BASE_URL + "/original/" + posterImage
                    } else if let backdropImage = item.backdropPath {
                        item.thumbnailImage = self.TMDB_IMAGES_BASE_URL + "/w300/" + backdropImage
                        item.originalImage = self.TMDB_IMAGES_BASE_URL + "/original/" + backdropImage
                    }
                    
                    return item
                }))
            }
        }
    }
}
