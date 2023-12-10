//
//  MoviesEndPoint.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

enum MoviesEndPoint: EndPointType {
	case getPopularMovies
    case searchMovies(query: String)
}

extension MoviesEndPoint {
	var environmentBaseURL : String {
        return "https://api.themoviedb.org"
	}
	
	var baseURL: URL {
		guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
		return url
	}
	
	var path: String {
		switch self {
		case .getPopularMovies:
			return "/3/movie/top_rated"
        case .searchMovies:
            return "/3/search/movie"
		}
	}
	
	var httpMethod: HTTPMethod {
		return .get
	}
	
	var task: HTTPTask {
		switch self {
		case .getPopularMovies:
            return .request
        case .searchMovies(let query):
            return .requestParameters(bodyParameters: nil, urlParameters: ["query": query])
		}
	}
	
	var headers: HTTPHeaders? {
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTkxYjVhNGIzZWY0ZTA4OWJjODc0YTE1NGM2ZTVhNSIsInN1YiI6IjY1NzRlNTZjNGJmYTU0MDBjNDA5MTBhMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.e7FF5uylKk6plrDx78QJXuCa52sYEuI2mwRDehkSqhg"
        
        return ["Authorization" : "Bearer \(accessToken)", "Content-Type" : "application/json"]
	}
}
