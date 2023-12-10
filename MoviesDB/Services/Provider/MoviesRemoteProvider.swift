//
//  MoviesRemoteProvider.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

protocol MoviesRemoteProviderProtocol {
    func getMovies(callback: @escaping MoviesCallback)
    func searchMovies(by query: String, callback: @escaping MoviesCallback)
    func loadImage(from path: String, callback: @escaping MovieImageCallback)
}

final class MoviesRemoteProvider: MoviesRemoteProviderProtocol {
    
    private let moviesNetworkManager: MoviesNetworkManager
    private let imageNetworkManager: ImageNetworkManager
    
    init(moviesNetworkManager: MoviesNetworkManager, imageNetworkManager: ImageNetworkManager) {
        self.moviesNetworkManager = moviesNetworkManager
        self.imageNetworkManager = imageNetworkManager
    }
    
    func getMovies(callback: @escaping MoviesCallback) {
        moviesNetworkManager.topMoviews(completion: callback)
    }
    
    func searchMovies(by query: String, callback: @escaping MoviesCallback) {
        moviesNetworkManager.searchMovies(by: query, completion: callback)
    }
    
    func loadImage(from path: String, callback: @escaping MovieImageCallback) {
        imageNetworkManager.movieImage(from: path) { result in
            switch result {
            case .success(let data):
                callback(.success(UIImage(data: data)))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
