//
//  MoviesResultModel.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// MoviesResultModel
// Decodable struct for MoviesResult
struct MoviesResultModel: Decodable {
    var results: [MovieModel]?
}
