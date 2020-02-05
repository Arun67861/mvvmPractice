//
//  MoviesItemTableViewCell.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 29/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import UIKit

class MoviesItemTableViewCell: UITableViewCell {

    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var content_View: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    lazy var viewModel: MoviesItemViewModel = MoviesItemViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.content_View.addShadowAndCornerRadius()
        self.posterImageView.layer.cornerRadius = 5
        self.activityIndicator.startAnimating()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureMoviesTableCell(model: MovieModelProtocol) {
        self.setNeedsLayout()
           self.layoutIfNeeded()
        self.titleLabel.text = model.title
        self.overViewLabel.text = model.overview
        self.dateLabel.text = model.release_date
        self.ratingsView.ratingsLabel.text = viewModel.loadRatingValue(from: model.vote_average)
        self.ratingsView.setValueForRating(value: viewModel.loadRatingProgressDetails(from: model.vote_average))
        self.imageView?.image = nil
        guard let poster = model.poster_path else {
            return
        }
        self.activityIndicator.startAnimating()
        self.viewModel.loadImage(from: URLRequest(url: URL(string: ImageDownload.downloadLargeImage(poster).imagePath)!)) { (response) -> (Void) in
            DispatchQueue.main.async { [unowned self] in
                self.posterImageView.image = response
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension UIView {
    func addShadowAndCornerRadius() {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
}
