//
//  MoviesItemViewModel.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

protocol MoviesItemViewModelProtocol {
    func loadImage(from request: URLRequest, completion: @escaping (ResponseImage))
}

protocol RatingViewModelProtocol {
    func loadRatingValue(from rating: Float?) -> String
    func loadRatingProgressDetails(from rating: Float?) -> (value: Float, isHighRating: Bool)
}

class MoviesItemViewModel: MoviesItemViewModelProtocol {
    func loadImage(from request: URLRequest, completion: @escaping (ResponseImage)) {
        DispatchQueue.global(qos: .background).async { 
            if let cachedImage = APIServices.shared.imageDownloader.imageCache?.image(for: request, withIdentifier: nil) {
                return completion(cachedImage)
            }
            APIServices.shared.downloadImageFromServer(with: request) { (response) -> (Void)in
                guard let imageValue = response.data else {
                    return
                }
                if let image = Image(data: imageValue) {
                    return completion(image)
                }
            }
        }
    }
}

extension MoviesItemViewModel: RatingViewModelProtocol {
    func loadRatingValue(from rating: Float?) -> String {
        guard let value = rating else {
            return ""
        }
        let actualValue = Int(value * 10)
        return String(actualValue)
    }
    
    func loadRatingProgressDetails(from rating: Float?) -> (value: Float, isHighRating: Bool) {
        guard let value = rating else {
            return (0.0, false)
        }
        let actualRating:Float = value/10
        var isHighRating: Bool = false
        
        if value > 7.0 {
            isHighRating = true
        } else {
            isHighRating = false
        }
        return(actualRating, isHighRating)
    }
}
