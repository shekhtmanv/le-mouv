//
//  Constants.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/2/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import Foundation

let apiKey = "d2410b322ebf3a4708322bced0a65dc0"
let basicUrl = "https://api.themoviedb.org/3/search/"

func movieUrl(lookingForSearchQuery query: String) -> String {
    return "\(basicUrl)movie?api_key=\(apiKey)&language=en-US&query=\(query)&page=1&include_adult=false"
}

func tvShowUrl(lookingForSearchQuery query: String) -> String {
    return "\(basicUrl)tv?api_key=\(apiKey)&language=en-US&query=\(query)&page=1"
}
