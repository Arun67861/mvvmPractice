//
//  MovieModel.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// MovieModelProtocol
// Protocol for MovieModel
protocol MovieModelProtocol {
    var title: String? {get}
    var popularity: Double? {get}
    var video: Bool? {get}
    var poster_path: String? {get}
    var release_date: String? {get}
    var overview: String? {get}
    var vote_average: Float? {get}
    var id:Int? {get}
}

// MovieModel
// Decodable struct for MovieModel
struct MovieModel: Decodable, MovieModelProtocol {
    var id: Int?
    var vote_average: Float?
    var release_date: String?
    var overview: String?
    var title: String?
    var popularity: Double?
    var video: Bool?
    var poster_path: String?
}
