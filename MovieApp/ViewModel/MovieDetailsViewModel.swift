//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 31/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation

protocol MovieDetailsViewModelProtocol: MoviesItemViewModelProtocol, RatingViewModelProtocol {
    func getTheGenersDetails(genersList: [MovieGenresProtocol]?) -> (String?, String?, String?)
    func loadMovieCastDetailsPage(from movieID: Int?)
    var movieCastList: [MovieCastModelProtocol] {get}
}

protocol MoviesDetailsViewDelegate: class {
    func didUpdateCollectionView()
}

class MovieDetailsViewModel: MoviesItemViewModel, MovieDetailsViewModelProtocol {
    
    var movieClient: MovieClient = MovieClient(configuration: .default)
    
    var movieCastList: [MovieCastModelProtocol] = []
    
    weak var delegate: MoviesDetailsViewDelegate?
    
    public init(delegateValue: MoviesDetailsViewDelegate) {
        super.init()
        self.delegate = delegateValue
    }
    
    func getTheGenersDetails(genersList: [MovieGenresProtocol]?) -> (String?, String?, String?) {
        guard let list = genersList else {
            return ("","","")
        }
        var genres1Value:String = ""
        if list.count > 0, let genres1 = list[0].name {
            genres1Value = genres1
        }
        var genres2Value:String = ""
        if list.count > 1, let genres2 = list[1].name {
            genres2Value = genres2
        }
        var genres3Value:String = ""
        if list.count > 2, let genres3 = list[2].name {
            genres3Value = genres3
        }
        return (genres1Value, genres2Value, genres3Value)
    }
    
    func loadMovieCastDetailsPage(from movieID: Int?) {
        guard let movieIdValue = movieID else {
            return
        }
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.movieClient.loadMovieCastDetails(from: movieIdValue, completion: { (result) in
                switch result {
                case .sucess(let response):
                    DispatchQueue.main.async { [unowned self] in
                        self?.movieCastList = response.cast ?? []
                        self?.delegate?.didUpdateCollectionView()
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    
}
