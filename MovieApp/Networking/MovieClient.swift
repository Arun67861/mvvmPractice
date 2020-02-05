//
//  MovieClient.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

protocol MovieListClientProtocol {
    func loadMovieFeed(from movieFeeds: MovieFeeds, completion: @escaping (Result<MoviesResultModel, APIError>) -> Void)
}

protocol MovieDetailsClientProtocol {
    func loadMovieDetails(from movieID: Int, completion: @escaping (Result<MovieDetailsModel, APIError>) -> Void)
}

protocol MovieCastClientProtocol {
    func loadMovieCastDetails(from movieID: Int, completion: @escaping (Result<MovieCastResults, APIError>) -> Void)
}

// MovieClient
// Class for handling Movie API's
class MovieClient: APIClient, MovieListClientProtocol, MovieDetailsClientProtocol,  MovieCastClientProtocol {
    var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    // loadMovieFeed
    // Methood will load the movie feed based on the movie feeds enum we are providing
    func loadMovieFeed(from movieFeeds: MovieFeeds, completion: @escaping (Result<MoviesResultModel, APIError>) -> Void) {
        guard let request = movieFeeds.request else {
            return
        }
        
        fetchData(from: request, decoding: { (json) -> MoviesResultModel? in
            guard let response = json as? MoviesResultModel else {
                return nil
            }
            return response
        }, completionHandler: completion)
    }
    
    // loadMovieDetails
    // Method will load the movie details from the selected movie Id
    func loadMovieDetails(from movieID: Int, completion: @escaping (Result<MovieDetailsModel, APIError>) -> Void) {
        
        guard let request = MovieFeeds.loadMovie(movieID).request else {
            return
        }
        
        fetchData(from: request, decoding: { (json) -> MovieDetailsModel? in
            guard let response = json as? MovieDetailsModel else {
                return nil
            }
            return response
        }, completionHandler: completion)
    }
    
    // loadMovieCastDetails
    // Method will load the movie cast details of the selected movie details
    func loadMovieCastDetails(from movieID: Int, completion: @escaping (Result<MovieCastResults, APIError>) -> Void) {
        
        guard let request = MovieFeeds.loadMovieCredits(movieID).request else {
            return
        }
        
        fetchData(from: request, decoding: { (json) -> MovieCastResults? in
            guard let response = json as? MovieCastResults else {
                return nil
            }
            return response
        }, completionHandler: completion)
    }
}
