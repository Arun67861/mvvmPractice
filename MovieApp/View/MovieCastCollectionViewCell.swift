//
//  MovieCastCollectionViewCell.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 31/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import UIKit

class MovieCastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var castContentView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var viewModel: MoviesItemViewModelProtocol = MoviesItemViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.castContentView.addShadowAndCornerRadius()
    }
    
    func configureMovieCastDetails(model: MovieCastModelProtocol) {
        self.nameLabel.text = model.name
        self.subNameLabel.text = model.character
        self.posterImageView.image = UIImage(systemName: "photo")
        guard let poster = model.profile_path else {
            return
        }
        self.viewModel.loadImage(from: URLRequest(url: URL(string: ImageDownload.downloadLargeImage(poster).imagePath)!)) { (response) -> (Void) in
            DispatchQueue.main.async { [weak self] in
                self?.posterImageView.image = response
            }
        }
        
    }

}
