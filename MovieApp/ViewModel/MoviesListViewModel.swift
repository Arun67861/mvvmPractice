//
//  MoviesListViewModel.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation


enum MoviesMode {
    case popular
    case nowPlaying
}

extension MoviesMode {
    func description() -> String{
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular Movies"
        }
    }
}

protocol MoviesListViewDelegate: class {
    func didUpdateTitleLabel(value: String)
    func didUpdateTableView()
    func didUpdateErrorDetails(error: APIError)
}

protocol MoviesListViewModelProtocol {
    var moviesList:[MovieModelProtocol] {get}
    func loadMovieListData(from feed: MovieFeeds)
    func loadMovieDetailsPage(from movieID: Int, completion: @escaping (MovieDetailsModelProtocol) -> ())
}

protocol HeaderProtocol {
    func setSelectedTab(value: Int)
}

class MoviesListViewModel: MoviesListViewModelProtocol {
    var moviesList: [MovieModelProtocol] = []
    weak var viewDelegate: MoviesListViewDelegate?
    var movieClient: (MovieListClientProtocol & MovieDetailsClientProtocol)!
    
    init(delegate: MoviesListViewDelegate, movieClientDetails: (MovieListClientProtocol & MovieDetailsClientProtocol)) {
        self.movieClient = movieClientDetails
        self.viewDelegate = delegate
    }
    
    func loadMovieListData(from feed: MovieFeeds) {
        MovieFeedsHandler.shared.incrementMoviePageCount()
        DispatchQueue.global(qos: .default).async {[weak self] in
            self?.movieClient.loadMovieFeed(from: feed) { (result) in
                switch result {
                case .sucess(let response):
                    guard let responseValue = response.results else {
                        return
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.moviesList.append(contentsOf: responseValue)
                        self?.viewDelegate?.didUpdateTableView()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.viewDelegate?.didUpdateErrorDetails(error: error)
                    }
                }
            }
        }
    }
    
    func loadMovieDetailsPage(from movieID: Int, completion: @escaping (MovieDetailsModelProtocol) -> ()) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.movieClient.loadMovieDetails(from: movieID, completion: { (result) in
                switch result {
                case .sucess(let response):
                    DispatchQueue.main.async {
                        completion(response)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.viewDelegate?.didUpdateErrorDetails(error: error)
                    }
                }
            })
        }
    }
    
}

extension MoviesListViewModel: HeaderProtocol {
    func setSelectedTab(value: Int) {
        MovieFeedsHandler.shared.reSetMoviePageCount()
        if value == 0 {
            self.viewDelegate?.didUpdateTitleLabel(value: MoviesMode.popular.description())
            clearMoviesList()
            self.loadMovieListData(from: .popular)
        } else {
            self.viewDelegate?.didUpdateTitleLabel(value: MoviesMode.nowPlaying.description())
            clearMoviesList()
            self.loadMovieListData(from: .nowPlaying)
        }
    }
    
    private func clearMoviesList() {
        self.moviesList.removeAll()
        self.viewDelegate?.didUpdateTableView()
    }
}
