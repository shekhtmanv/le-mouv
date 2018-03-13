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
    
    func retrieveMoviesJson(searchQuery: String, completion: @escaping ([Film]) -> () ) {
        Alamofire.request(movieUrl(lookingForSearchQuery: searchQuery)).responseJSON { (response) in
            guard let json = response.result.value as? [String: AnyObject] else { return }
            guard let resultsArray = json["results"] as? [[String: AnyObject]] else { return }
            
            var films = [Film]()
            
            for dictionary in resultsArray {
                let film = Film()
                let imageUrl = "http://image.tmdb.org/t/p/w185\(dictionary["poster_path"]!)"
                
                film.title = dictionary["original_title"] as? String
                film.rating = dictionary["vote_average"] as? Float
                film.year = dictionary["release_date"] as? String
                film.overview = dictionary["overview"] as? String
                film.type = "Movie"
                film.posterName = imageUrl
                
                films.append(film)
            }
            
            DispatchQueue.main.async {
                completion(films)
            }
            
        }
    }
    
    func retrieveTvShowsJson(searchQuery: String, completion: @escaping ([Film]) -> () ) {
        Alamofire.request(tvShowUrl(lookingForSearchQuery: searchQuery)).responseJSON { (response) in
            guard let json = response.result.value as? [String: AnyObject] else { return }
            guard let resultsArray = json["results"] as? [[String: AnyObject]] else { return }
            
            var films = [Film]()
            
            for dictionary in resultsArray {
                let film = Film()
                let imageUrl = "http://image.tmdb.org/t/p/w185\(dictionary["poster_path"]!)"
                
                film.title = dictionary["name"] as? String
                film.rating = dictionary["vote_average"] as? Float
                film.year = dictionary["first_air_date"] as? String
                film.overview = dictionary["overview"] as? String
                film.type = "TV Show"
                film.posterName = imageUrl
                
                films.append(film)
            }
            
            DispatchQueue.main.async {
                completion(films)
            }
            
        }
    }
    
}
