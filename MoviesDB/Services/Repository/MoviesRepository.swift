//
//  MoviesRepository.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

typealias MoviesCallback = (Result<MoviesResponse, Error>) -> Void
typealias MovieImageCallback = (Result<UIImage?, Error>) -> Void

protocol MoviesRepositoryProtocol {
    func getMovies(isOnline: Bool, callback: @escaping MoviesCallback)
    func searchMovies(isOnline: Bool, by query: String, callback: @escaping MoviesCallback)
    func loadImage(from path: String, callback: @escaping MovieImageCallback)
}

final class MoviesRepository: MoviesRepositoryProtocol {
    
    private let remoteProvider: MoviesRemoteProviderProtocol
    private let localProvider: MoviesLocalProviderProtocol
    private let cacheProvider: MoviesMemoryCacheProviderProtocol
    
    init(
        remoteProvider: MoviesRemoteProviderProtocol,
        localProvider: MoviesLocalProviderProtocol,
        cacheProvider: MoviesMemoryCacheProviderProtocol
    ) {
        self.remoteProvider = remoteProvider
        self.localProvider = localProvider
        self.cacheProvider = cacheProvider
    }
    
    func getMovies(isOnline: Bool, callback: @escaping MoviesCallback) {
        if isOnline {
            remoteProvider.getMovies { [weak self] result in
                switch result {
                case .success(let remoteMovieResult):
                    self?.localProvider.saveMovies(remoteMovieResult.results)
                    callback(.success(remoteMovieResult))
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        } else {
            localProvider.getMovies(callback: callback)
        }
    }
    
    func searchMovies(isOnline: Bool, by query: String, callback: @escaping MoviesCallback) {
        if isOnline {
            remoteProvider.searchMovies(by: query, callback: callback)
        } else {
            localProvider.searchMovies(by: query, callback: callback)
        }
    }
    
    func loadImage(from path: String, callback: @escaping MovieImageCallback) {
        if let image = cacheProvider.loadImage(from: path) {
            callback(.success(image))
            return
        }
        
        remoteProvider.loadImage(from: path) { [weak self] result in
            switch result {
            case .success(let image):
                self?.cacheProvider.saveImage(image, from: path)
                callback(.success(image))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
