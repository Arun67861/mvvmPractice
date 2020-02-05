//
//  MovieFeedsHandler.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 01/02/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation


final class MovieFeedsHandler {
    static let shared = MovieFeedsHandler()
    private var moviePageCount = 0
    private init(){}
    
    func incrementMoviePageCount() {
        moviePageCount += 1
    }
    
    func reSetMoviePageCount() {
        moviePageCount = 0
    }
    
    func currentPageCount() -> String {
        return String(moviePageCount)
    }
}
