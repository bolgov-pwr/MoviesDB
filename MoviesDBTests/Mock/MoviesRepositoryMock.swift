//
//  MoviesRepositoryMock.swift
//  MoviesDBTests
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import Foundation
@testable import MoviesDB

final class MoviesRepositoryMock: MoviesRepositoryProtocol {
    
    var allMovies: Result<MoviesResponse, Error> = .failure("".toError())
    
    var searchedMovies: Result<MoviesResponse, Error> = .failure("".toError())
    
    func getMovies(isOnline: Bool, callback: @escaping MoviesDB.MoviesCallback) {
        callback(allMovies)
    }
    
    func searchMovies(isOnline: Bool, by query: String, callback: @escaping MoviesDB.MoviesCallback) {
        callback(searchedMovies)
    }
    
    func loadImage(from path: String, callback: @escaping MoviesDB.MovieImageCallback) {
        
    }
}
