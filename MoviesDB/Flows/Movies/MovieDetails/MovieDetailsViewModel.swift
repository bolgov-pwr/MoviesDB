//
//  MovieDetailsViewModel.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var title: String { get }
    func calculateOccurrence() -> [Occurrence]
}

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    
    var title: String {
        return movie.title
    }
    
    private let movie: Movie
    private let calculator: OccurrenceCalculatorProtocol
    
    init(movie: Movie, calculator: OccurrenceCalculatorProtocol) {
        self.movie = movie
        self.calculator = calculator
    }
    
    func calculateOccurrence() -> [Occurrence] {
        return calculator.calculateOccurrence(of: movie)
    }
}
