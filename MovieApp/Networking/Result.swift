//
//  Result.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

// Result
// Enum whuch will returen the success and failure result
enum Result<T,U> where U: Error {
    case sucess(T)
    case failure(U)
}
