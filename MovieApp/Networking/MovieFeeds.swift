//
//  MovieFeeds.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// MovieFeeds
// Protocol which will mention the path of API
enum MovieFeeds {
    case nowPlaying
    case popular
    case loadMovie(Int)
    case loadMovieCredits(Int)
}

extension MovieFeeds: EndPoint {
    // currentPage
    // Will return the page cound
    var currentPage: URLQueryItem {
        return URLQueryItem(name: "page", value: MovieFeedsHandler.shared.currentPageCount())
    }
    
    // base
    // Will return the base url for the API
    var base: String {
        return "https://api.themoviedb.org"
    }
    
    // path:
    // Will return the path details
    var path: String {
        switch self {
        case .nowPlaying:
            return "/3/movie/now_playing"
        case .popular:
            return "/3/movie/popular"
        case .loadMovie(let idValue):
            return "/3/movie/\(idValue)"
        case .loadMovieCredits(let idValue):
            return "/3/movie/\(idValue)/credits"
        }
    }
}

// ImageDownload
// Enum will provide the details for download image
enum ImageDownload {
    case downloadLargeImage(String)
    case downloadSmallImage(String)
}
// Extention for providing the default path
extension ImageDownload {
    var imagePath: String {
        switch self {
        case .downloadLargeImage(let imageURL):
            return "https://image.tmdb.org/t/p/w185_and_h278_bestv2\(imageURL)"
        case .downloadSmallImage(let imageURL):
            return "https://image.tmdb.org/t/p/w100_and_h120_bestv2\(imageURL)"
        }
    }
}
