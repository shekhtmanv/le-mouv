//
//  ApiService.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/8/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit
import Alamofire

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func retrieveMoviesJson(searchQuery: String, completion: @escaping ([Movie]) -> () ) {
        Alamofire.request(movieUrl(lookingForSearchQuery: searchQuery)).responseJSON { (response) in
            guard let json = response.result.value as? [String: AnyObject] else { return }
            guard let resultsArray = json["results"] as? [[String: AnyObject]] else { return }
            
            var movies = [Movie]()
            
            for dictionary in resultsArray {
                let movie = Movie()
                let imageUrl = "http://image.tmdb.org/t/p/w185\(dictionary["poster_path"]!)"
                
                movie.title = dictionary["original_title"] as? String
                movie.rating = dictionary["vote_average"] as? Float
                movie.year = dictionary["release_date"] as? String
                movie.overview = dictionary["overview"] as? String
                movie.posterName = imageUrl
                
                movies.append(movie)
            }
            
            DispatchQueue.main.async {
                completion(movies)
            }
            
        }
    }
    
    func retrieveTvShowsJson(searchQuery: String, completion: @escaping ([Movie]) -> () ) {
        Alamofire.request(tvShowUrl(lookingForSearchQuery: searchQuery)).responseJSON { (response) in
            guard let json = response.result.value as? [String: AnyObject] else { return }
            guard let resultsArray = json["results"] as? [[String: AnyObject]] else { return }
            
            var movies = [Movie]()
            
            for dictionary in resultsArray {
                let movie = Movie()
                let imageUrl = "http://image.tmdb.org/t/p/w185\(dictionary["poster_path"]!)"
                
                movie.title = dictionary["name"] as? String
                movie.rating = dictionary["vote_average"] as? Float
                movie.year = dictionary["first_air_date"] as? String
                movie.overview = dictionary["overview"] as? String
                movie.posterName = imageUrl
                
                movies.append(movie)
            }
            
            DispatchQueue.main.async {
                completion(movies)
            }
            
        }
    }
    
}
