//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 30/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genres3Label: UILabel!
    @IBOutlet weak var genres2Label: UILabel!
    @IBOutlet weak var genres1Label: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    var movieDetails: MovieDetailsModelProtocol?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var posterImageView: UIImageView!
    var viewModel: MovieDetailsViewModelProtocol!
    let castIdentifier: String = "castIdentifier"
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailsViewModel(delegateValue: self)
        castCollectionView.register(UINib(nibName: "MovieCastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: castIdentifier)
        setUpViewDetails()
        viewModel.loadMovieCastDetailsPage(from: movieDetails?.id)
    }
    
    func setUpViewDetails() {
        self.genres1Label.text = viewModel.getTheGenersDetails(genersList: movieDetails?.genres).0
        self.genres2Label.text = viewModel.getTheGenersDetails(genersList: movieDetails?.genres).1
        self.genres3Label.text = viewModel.getTheGenersDetails(genersList: movieDetails?.genres).2
        self.releaseDateLabel.text = movieDetails?.release_date
        self.languageLabel.text = movieDetails?.spoken_languages?.first?.name
        self.runtimeLabel.text = "\(movieDetails?.runtime ?? 0)"
        self.overViewLabel.text = movieDetails?.overview
        self.ratingsView.view.backgroundColor = UIColor.clear
        self.ratingsView.ratingsLabel.text = viewModel.loadRatingValue(from: movieDetails?.vote_average)
        self.ratingsView.showAnimation = true
        self.ratingsView.setValueForRating(value: viewModel.loadRatingProgressDetails(from: movieDetails?.vote_average))
        self.titleLabel.text = movieDetails?.title
        guard let poster = movieDetails?.poster_path else {
            return
        }
        self.viewModel.loadImage(from: URLRequest(url: URL(string: ImageDownload.downloadLargeImage(poster).imagePath)!)) { (response) -> (Void) in
            DispatchQueue.main.async { [weak self] in
                self?.posterImageView.image = response
            }
        }
    }
}

// MARK: Table view datasource
extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieCastList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: castIdentifier, for: indexPath) as? MovieCastCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureMovieCastDetails(model: viewModel.movieCastList[indexPath.row])
        return cell
    }
}

// MARK: Table view delegate
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 140)
    }
}

// MARK: MoviesDetailsViewDelegate
extension MovieDetailsViewController: MoviesDetailsViewDelegate {
    // Delegate method for updating collectionview
    func didUpdateCollectionView() {
        self.castCollectionView.reloadData()
    }
}
