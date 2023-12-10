//
//  ImageNetworkManager.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

final class ImageNetworkManager: NetworkManagerProtocol {
    
    init (router: Router<ImageEndPoint> = Router<ImageEndPoint>()) {
        self.router = router
    }
    
    private let router: Router<ImageEndPoint>
    
    func movieImage(from path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        router.request(.getImage(path: path)) { [weak self] data, response, error in
            guard let sSelf = self else { return }
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = sSelf.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(ServerError.canNotParseData))
                        return
                    }
                    completion(.success(responseData))
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError.toError()))
                }
            }
        }
    }
}
