//
//  NetworkManagerProtocol.swift
//
//  Created by Ivan Bolgov on 08.09.2020.
//  Copyright © 2020 Ivan Bolgov. All rights reserved.
//

import Foundation
import SwiftUI

enum NetworkResponse: String {
	enum Result<String> {
		case success
		case failure(String)
	}
	case success
	case authenticationError = "Authentication error"
	case badRequest = "Bad request"
	case outdated = "Outdated"
    case failed = "Network request failed"
}

protocol NetworkManagerProtocol {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponse.Result<String>
    func handle<T: Decodable>(_ completion: NetworkRouterResult, as: T.Type) -> Result<T, Error>
}

extension NetworkManagerProtocol {
	func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponse.Result<String> {
		switch response.statusCode {
		case 200...299: return .success
		case 401...499: return .failure(NetworkResponse.authenticationError.rawValue)
		case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
		case 600: return .failure(NetworkResponse.outdated.rawValue)
		case 500: return .failure(NetworkResponse.badRequest.rawValue)
		default: return .failure(NetworkResponse.failed.rawValue)
		}
	}
	
    func handle<T: Decodable>(_ completion: NetworkRouterResult, as: T.Type) -> Result<T, Error> {
        var resultCompletion: Result<T, Error>?
        
        guard completion.error == nil else {
            resultCompletion = .failure(completion.error!)
            return resultCompletion!
        }
        
        if let response = completion.response as? HTTPURLResponse {
            let result = handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = completion.data else {
                    resultCompletion = .failure(ServerError.canNotParseData)
                    return resultCompletion!
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: responseData)
                    resultCompletion = .success(decoded)
                } catch {
                    resultCompletion = .failure(ServerError.canNotParseData)
                }
            case .failure(let networkFailureError):
                resultCompletion = .failure(networkFailureError.toError())
            }
        }
        return resultCompletion ?? .failure(ServerError.canNotParseData)
    }
}
