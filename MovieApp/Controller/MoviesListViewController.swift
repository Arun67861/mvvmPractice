//
//  ViewController.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import UIKit

typealias ResponseImage = (UIImage) -> ()
typealias Image = UIImage

class MoviesListViewController: UIViewController {

    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moviesTableView: UITableView!
    var viewModel: MoviesListViewModel!
    let identifier = "moviesListIdentifier"
    let movieDetailsControllerIdentifier = "MovieDetailsViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = MoviesMode.popular.description()
        self.viewModel = MoviesListViewModel(delegate: self, movieClientDetails: MovieClient(configuration: .default))
        moviesTableView.register(UINib(nibName: "MoviesItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: identifier)
        self.viewModel.loadMovieListData(from: .popular)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 227
    }
    
    // Method for handling navigation
    fileprivate func navigateToMovieDetails(moviesID: Int?) {
        guard let movieIdentifier = moviesID else {
            return
        }
        self.activityLoader.startAnimating()
        viewModel.loadMovieDetailsPage(from: movieIdentifier) { response in
            DispatchQueue.main.async { [weak self] in
                self?.activityLoader.stopAnimating()
                self?.loadMovieDetailsScreen(detailsModel: response)
            }
        }
    }
    // Method for loading MovieDetails screen
    private func loadMovieDetailsScreen(detailsModel: MovieDetailsModelProtocol) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let movieDetailsViewController = storyBoard.instantiateViewController(identifier: movieDetailsControllerIdentifier) as? MovieDetailsViewController else {
            return
        }
        movieDetailsViewController.movieDetails = detailsModel
        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: Segment Action
extension MoviesListViewController {
    @IBAction func selectedMoviesMode(_ sender: Any) {
        if let selectedOption = sender as? UISegmentedControl {
            viewModel.setSelectedTab(value: selectedOption.selectedSegmentIndex)
        }
    }
}

// MARK: Table view datasource
extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MoviesItemTableViewCell else {
            return UITableViewCell()
        }
        cell.configureMoviesTableCell(model: viewModel.moviesList[indexPath.row])
        return cell
    }
}

// MARK: Table view delegate
extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = UIColor.red
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            self.moviesTableView.tableFooterView = spinner
            self.moviesTableView.tableFooterView?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                self?.viewModel.loadMovieListData(from: self?.segment.selectedSegmentIndex == 0 ? MovieFeeds.popular : MovieFeeds.nowPlaying)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateToMovieDetails(moviesID: viewModel.moviesList[indexPath.row].id)
    }
}

// MARK: MoviesListViewDelegate
extension MoviesListViewController: MoviesListViewDelegate {
    func didUpdateErrorDetails(error: APIError) {
        DispatchQueue.main.async {  [weak self] in
            self?.activityLoader.stopAnimating()
            self?.showErrorAlert(message: error.description())
        }
    }
    
    // Delegate method for updating tableview
    func didUpdateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.moviesTableView.reloadData()
        }
    }
    
    // Delegate method will update title when selecting segments
    func didUpdateTitleLabel(value: String) {
        titleLabel.text = value
    }
}
