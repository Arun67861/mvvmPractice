//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import XCTest
@testable import MovieApp

class MovieAppTests: XCTestCase {
    
    var viewModel = MoviesListViewModel(delegate: MockView(), movieClientDetails: MockMovieClient())
    

    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMoviesList() {
        
        XCTAssertEqual(false, viewModel.movieClient.isLodMoviesDetailsCalled)
        let moviesExpectation = expectation(description: "movies")
        viewModel.loadMovieDetailsPage(from: 2) { (response) in
            XCTAssertEqual(true, self.viewModel.movieClient.isLodMoviesDetailsCalled, "Sucess")
            moviesExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
    }

}

extension MovieDetailsClientProtocol {
    var isLodMoviesDetailsCalled: Bool {
        return false
    }
}

class MockMovieClient: MovieDetailsClientProtocol, MovieListClientProtocol {
    var isLodMoviesDetailsCalled = false
    var isLoadMovieFeedsCalled = false
    func loadMovieDetails(from movieID: Int, completion: @escaping (Result<MovieDetailsModel, APIError>) -> Void) {
        DispatchQueue.main.async {
            self.isLodMoviesDetailsCalled = true
        }
        completion(.sucess(MockMovieDetailsModel()))
    }
    
    func loadMovieFeed(from movieFeeds: MovieFeeds, completion: @escaping (Result<MoviesResultModel, APIError>) -> Void) {
        isLoadMovieFeedsCalled = true
    }
    
    
}

class MockMoviesListViewModel: MoviesListViewModelProtocol {
    var moviesList: [MovieModelProtocol] = [MockModel(),MockModel()]
    
    var loadMovieListCalled = false
    var loadMovieDetailsPage = false
    
    func loadMovieListData(from feed: MovieFeeds) {
        loadMovieListCalled = true
    }
    
    func loadMovieDetailsPage(from movieID: Int, completion: @escaping (MovieDetailsModelProtocol) -> ()) {
        completion(<#MovieDetailsModelProtocol#>)
    }
}

class MockModel: MovieModelProtocol {
    var title: String? {
        return "Hello"
    }
    
    var popularity: Double?
    
    var video: Bool?
    
    var poster_path: String?
    
    var release_date: String?
    
    var overview: String?
    
    var vote_average: Float?
    
    var id: Int?
    
}

class MockMovieDetailsModel: MovieDetailsModel {
    var response:Bool = true
}

class MockView: MoviesListViewDelegate {
    func didUpdateTitleLabel(value: String) {
        
    }
    
    func didUpdateTableView() {
        
    }
    
    func didUpdateErrorDetails(error: APIError) {
        
    }
    
    
}
