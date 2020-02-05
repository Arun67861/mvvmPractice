//
//  APIClient.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// APIClient
// Prootocol which will mention the methods for client access
protocol APIClient {
    var session: URLSession {get}
    func fetchData<T: Decodable>(from request: URLRequest, decoding: @escaping (Decodable) -> T?, completionHandler completion: @escaping(Result<T, APIError>) -> Void)
}

extension APIClient {
    typealias APICompletionHandler = (Decodable?, APIError?) -> Void
    
    private func decodeData<T: Decodable>(from request: URLRequest, decodingType: T.Type, completion: @escaping APICompletionHandler) {
        
        APIServices.shared.loadDataFromServer(with: request) { (response, error) in
            
            guard let data = response else {
                if let errorValue = error {
                    return completion(nil, errorValue)
                }
                return completion(nil, .invalidData)
            }
            guard let genricData = try? JSONDecoder().decode(decodingType, from: data) else {
                return completion(nil, .parsingError)
            }
            return completion(genricData, nil)
        }
    }
    
    func fetchData<T: Decodable>(from request: URLRequest, decoding: @escaping (Decodable) -> T?, completionHandler completion: @escaping(Result<T, APIError>) -> Void) {
        
        let _ = decodeData(from: request, decodingType: T.self) { (response, error) in
            guard let response = response else {
                if let error = error {
                    return completion(.failure(error))
                } else {
                    return completion(.failure(.invalidResponse))
                }
            }
            
            guard let decodable = decoding(response) else {
                return completion(.failure(.parsingError))
            }
            completion(.sucess(decodable))
        }
    }
}
