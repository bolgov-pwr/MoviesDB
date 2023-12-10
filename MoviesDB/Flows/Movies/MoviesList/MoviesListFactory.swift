//
//  MoviesListFactory.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

protocol MoviesListFactoryProtocol {
    func buildMoviesList() -> MoviesListViewController
}

final class MoviesListFactory: MoviesListFactoryProtocol {
    func buildMoviesList() -> MoviesListViewController {
        let moviesNetwork = MoviesNetworkManager()
        let imagesNetwork = ImageNetworkManager()
        
        let remoteProvider = MoviesRemoteProvider(moviesNetworkManager: moviesNetwork, imageNetworkManager: imagesNetwork)
        let localProvider = MoviesLocalProvider(coreDataManager: CoreDataManager(modelName: "MoviesDB"))
        let cacheProvider = MoviesMemoryCacheProvider(imageCache: ImageCache())
        
        let repo = MoviesRepository(remoteProvider: remoteProvider, localProvider: localProvider, cacheProvider: cacheProvider)
        
        let viewModel = MovieListViewModel(moviesRepo: repo)
        let viewController = MoviesListViewController(viewModel: viewModel)
        return viewController
    }
}
