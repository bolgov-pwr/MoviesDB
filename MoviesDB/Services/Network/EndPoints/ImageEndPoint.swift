//
//  ImageEndPoint.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

enum ImageEndPoint: EndPointType {
    case getImage(path: String)
}

extension ImageEndPoint {
    var environmentBaseURL : String {
        return "https://image.tmdb.org"
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getImage(let path):
            return "/t/p/w185\(path)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .getImage:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return [:]
    }
}
