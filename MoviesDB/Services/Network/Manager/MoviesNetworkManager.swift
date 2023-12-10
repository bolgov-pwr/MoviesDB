//
//  MoviesNetworkManager.swift
//
//  Created by Ivan Bolgov on 02.09.2020.
//  Copyright © 2020 Ivan Bolgov. All rights reserved.
//

import Foundation

final class MoviesNetworkManager: NetworkManagerProtocol {
    
    init (router: Router<MoviesEndPoint> = Router<MoviesEndPoint>()) {
        self.router = router
    }
	
	private let router: Router<MoviesEndPoint>
	
    func topMoviews(completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        router.request(.getPopularMovies) { [weak self] data, response, error in
            guard let sSelf = self else { return }
            completion(sSelf.handle(NetworkRouterResult(data, response, error), as: MoviesResponse.self))
        }
	}

    func searchMovies(by query: String, completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        router.request(.searchMovies(query: query)) { [weak self] data, response, error in
            guard let sSelf = self else { return }
            completion(sSelf.handle(NetworkRouterResult(data, response, error), as: MoviesResponse.self))
        }
    }
}
