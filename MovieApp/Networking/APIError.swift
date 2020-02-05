//
//  APIError.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// APIError
// Enum which will provide the actual error case
enum APIError: Error {
    case apiFailure(Error)
    case invalidResponse
    case invalidStatusCode
    case invalidData
    case parsingError
    case noNetwork
}

extension APIError {
    func description() -> String {
        switch self {
        case .apiFailure(let error):
            return "\(error.localizedDescription)"
        case .invalidResponse, .invalidStatusCode, .invalidData, .parsingError:
            return "Netowrk error. Please try again!"
        case .noNetwork:
            return "Please connect with network!"
        }
    }
}
