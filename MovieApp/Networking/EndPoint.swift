//
//  EndPoint.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// EndPoint
// Protocol which will mention the base path and current page
protocol EndPoint {
    var base: String {get}
    var path: String {get}
    var currentPage: URLQueryItem {get}
}

extension EndPoint {
    // apiKey
    // Which will returnt the api key
    var apiKey: URLQueryItem {
        return URLQueryItem(name: "api_key", value: "34a92f7d77a168fdcd9a46ee1863edf1")
    }
    
    // urlComponent
    // Return the URL component embeded with base and path
    var urlComponent: URLComponents? {
        var component = URLComponents(string: base)
        component?.path = path
        component?.queryItems = [apiKey, currentPage]
        return component
    }
    // request
    // Will return the URL Request
    var request: URLRequest? {
        guard let url = urlComponent?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
}
