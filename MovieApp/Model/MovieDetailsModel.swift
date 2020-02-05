//
//  MovieDetailsModel.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 30/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// MovieDetailsModelProtocol
// Protocol for MovieDetailsModel
protocol MovieDetailsModelProtocol {
    var poster_path: String? {get}
    var original_language: String? {get}
    var original_title: String? {get}
    var overview: String? {get}
    var release_date: String? {get}
    var revenue:Int? {get}
    var title: String? {get}
    var vote_average:Float? {get}
    var runtime: Int? {get}
    var genres: [MovieGenres]? {get}
    var spoken_languages: [SpokenLanguage]? {get}
    var id:Int? {get}
}

// MovieDetailsModel
// Decodable struct for MovieDetailsModel
class MovieDetailsModel:Decodable, MovieDetailsModelProtocol {
    var title: String?
    var poster_path: String?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var release_date: String?
    var revenue: Int?
    var vote_average:Float?
    var runtime: Int?
    var genres: [MovieGenres]?
    var spoken_languages: [SpokenLanguage]?
    var id:Int? 
}

// MovieGenresProtocol
// Protocol for MovieGenresProtocol
protocol MovieGenresProtocol {
    var id:Int? {get}
    var name: String? {get}
}

// MovieGenres
// Decodable struct for MovieGenres
class MovieGenres: Decodable, MovieGenresProtocol {
    var id: Int?
    var name: String?
}

// SpokenLanguage
// Decodable struct for SpokenLanguage
class SpokenLanguage: Decodable {
    var name: String?
}


