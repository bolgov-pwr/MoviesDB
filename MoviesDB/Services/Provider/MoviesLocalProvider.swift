//
//  MoviesLocalProvider.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import Foundation

protocol MoviesLocalProviderProtocol {
    func getMovies(callback: @escaping MoviesCallback)
    func searchMovies(by query: String, callback: @escaping MoviesCallback)
    func saveMovies(_ movies: [Movie])
}

final class MoviesLocalProvider: MoviesLocalProviderProtocol {
    
    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func getMovies(callback: @escaping MoviesCallback) {
        coreDataManager.fetch(type: MovieEntity.self, predicate: nil, mode: .background) { movies in
            guard let movies else { return }
            
            let dataMovies =  movies.map { Movie(from: $0) }
            let result = MoviesResponse(results: dataMovies)
            callback(.success(result))
        }
    }
    
    func searchMovies(by query: String, callback: @escaping MoviesCallback) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        
        coreDataManager.fetch(type: MovieEntity.self, predicate: predicate, mode: .background) { movies in
            guard let movies else { return }
            
            let dataMovies =  movies.map { Movie(from: $0) }
            let result = MoviesResponse(results: dataMovies)
            callback(.success(result))
        }
    }
    
    func saveMovies(_ movies: [Movie]) {
        coreDataManager.clear(type: MovieEntity.self, mode: .background) { [weak self] _ in
            for movie in movies {
                self?.coreDataManager.create(type: MovieEntity.self, mode: .background, initialization: { entity in
                    entity?.id = movie.id
                    entity?.imagePath = movie.posterPath
                    entity?.title = movie.title
                    entity?.rating = movie.voteAverage ?? 0.0
                }, completion: nil)
            }
        }
    }
    
}
