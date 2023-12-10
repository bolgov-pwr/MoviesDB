//
//  MovieDetailsFactory.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import UIKit

protocol MovieDetailsFactoryProtocol {
    func buildMovieDetails(of movie: Movie) -> MovieDetailsViewController
}

final class MovieDetailsFactory: MovieDetailsFactoryProtocol {
    func buildMovieDetails(of movie: Movie) -> MovieDetailsViewController {
        let viewModel = MovieDetailsViewModel(movie: movie, calculator: OccurrenceCalculator())
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        return viewController
    }
}
