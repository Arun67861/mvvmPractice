//
//  MovieCastModel.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 01/02/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// MovieCastModelProtocol
// Protocol for MovieCastModel
protocol MovieCastModelProtocol {
    var cast_id: Int? {get}
    var character: String? {get}
    var name: String? {get}
    var profile_path: String? {get}
    var order: Int? {get}
}

// MovieCastModel
// Decodable struct for MovieCastModel
class MovieCastModel: Decodable, MovieCastModelProtocol {
    var cast_id: Int?
    var character: String?
    var name: String?
    var profile_path: String?
    var order: Int?
}

// MovieCastResultsProtocol
// Protocol for MovieCastResults
protocol MovieCastResultsProtocol {
    var cast: [MovieCastModel]? {get}
}

// MovieCastResults
// Decodable struct for MovieCastResults
class MovieCastResults: Decodable, MovieCastResultsProtocol {
    var cast: [MovieCastModel]?
}

