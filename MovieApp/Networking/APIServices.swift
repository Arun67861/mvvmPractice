//
//  APIServices.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//


import Alamofire
import AlamofireImage

// ApiServicesProtocol
// Protocol which will used for handling API serrvice calls through Alamofire
protocol ApiServicesProtocol {
    associatedtype ResponseData
    func loadDataFromServer(with request: URLRequest, completionHandler completion: @escaping(ResponseData?, APIError?) -> Void)
    func downloadImageFromServer(with request: URLRequestConvertible, completionHandler completion: @escaping ImageDataResponse)
}

typealias ImageDataResponse = (DataResponse<Image>) -> (Void)

// APIServices
// Class which will handle the API services through Alamofire SDK
class APIServices: ApiServicesProtocol {
    static let shared = APIServices()
    lazy var imageDownloader: ImageDownloader = ImageDownloader()
    typealias ResponseData = Data
    
    private init(){}
    
    // loadDataFromServer
    // Method will reture the API result based on the request we are sending
    func loadDataFromServer(with request: URLRequest, completionHandler completion: @escaping(Data?, APIError?) -> Void) {
        
        if isConnected() {
            Alamofire.request(request).responseJSON { (response) in
                
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        return completion(nil, .invalidData)
                    }
                    return completion(data, nil)
                    
                } else {
                    return completion(nil, .invalidResponse)
                }
            }
        } else {
            return completion(nil, .noNetwork)
        }
    }
    
    // downloadImageFromServer
    // Method will download the image and cauch using alamofire Image cache
    func downloadImageFromServer(with request: URLRequestConvertible, completionHandler completion: @escaping ImageDataResponse) {
        if isConnected() {
            imageDownloader.download(request) { (response) in
                completion(response)
            }
        }
    }
    
    private func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
