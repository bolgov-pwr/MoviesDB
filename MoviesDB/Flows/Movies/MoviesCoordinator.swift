//
//  MoviesCoordinator.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import UIKit

final class MoviesCoordinator: Coordinator {
    
    let rootViewController: UINavigationController
    
    private let listFactory: MoviesListFactoryProtocol
    private let detailsFactory: MovieDetailsFactoryProtocol
    
    init(
        rootViewController: UINavigationController,
        listFactory: MoviesListFactoryProtocol,
        detailsFactory: MovieDetailsFactoryProtocol
    ) {
        self.rootViewController = rootViewController
        self.listFactory = listFactory
        self.detailsFactory = detailsFactory
    }
    
    override func start() {
        let vc = listFactory.buildMoviesList()
        vc.delegate = self
        rootViewController.pushViewController(vc, animated: true)
    }
}

// MARK: MoviesListViewControllerDelegate

extension MoviesCoordinator: MoviesListViewControllerDelegate {
    func openDetails(of movie: Movie) {
        let vc = detailsFactory.buildMovieDetails(of: movie)
        rootViewController.pushViewController(vc, animated: true)
    }
}
