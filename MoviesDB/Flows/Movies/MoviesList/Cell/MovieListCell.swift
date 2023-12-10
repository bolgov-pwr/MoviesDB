//
//  MovieListCell.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

final class MovieListCell: UITableViewCell, ClassIdentifiable, NibIdentifiable {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var viewModel: MoviesListCellViewModelProtocol? {
        didSet {
            setup()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }
    
    private func setup() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.movie.title
        
        if let voteAverage = viewModel.movie.voteAverage {
            ratingLabel.text = String(format: "%.2f", voteAverage)
        }
        
        viewModel.loadImage { [weak self] result in
            guard case .success(let image) = result,
                  self?.viewModel?.movie.posterPath == viewModel.movie.posterPath  else {
                return
            }
            
            DispatchQueue.executeOnMain {
                self?.movieImageView.image = image
            }
        }
    }
}
