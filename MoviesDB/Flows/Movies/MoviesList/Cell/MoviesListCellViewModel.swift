//
//  MoviesListCellViewModel.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

protocol MoviesListCellViewModelProtocol {
    var movie: Movie { get }
    func loadImage(callback: @escaping (Result<UIImage?, Error>) -> Void)
}

final class MoviesListCellViewModel: MoviesListCellViewModelProtocol {
   
    let movie: Movie
    
    private let repo: MoviesRepositoryProtocol
    
    init(_ movie: Movie, repo: MoviesRepositoryProtocol) {
        self.movie = movie
        self.repo = repo
    }
    
    func loadImage(callback: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let imagePath = movie.posterPath else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.repo.loadImage(from: imagePath, callback: { result in
                if case .success(let image) = result {
                    callback(.success(image))
                }
            })
        }
    }
}

extension MoviesListCellViewModel: Equatable {
    static func ==(lhs: MoviesListCellViewModel, rhs: MoviesListCellViewModel) -> Bool {
        return lhs.movie == rhs.movie
    }
}
