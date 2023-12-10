//
//  Router.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
	
	init(session: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.default)) {
		self.session = session
	}
	
	private var task: URLSessionDataTaskProtocol?
	private let session: URLSessionProtocol
	
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {

        let request = buildRequest(from: route)
        task = session.dataTask(with: request, path: route.path) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            
            completion(data, response, error)
        }
        self.task?.resume()
    }
	
	fileprivate func buildRequest(from route: EndPoint) -> URLRequest {
		var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
		request.httpMethod = route.httpMethod.rawValue
		request.allHTTPHeaderFields = route.headers
		switch route.task {
		case .request:
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		case .requestParameters(let bodyParameters, let urlParameters):
			self.configureParameters(bodyParameters: bodyParameters,
										 urlParameters: urlParameters,
										 streamData: nil,
										 request: &request)
		}
		return request
	}
	
	fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, streamData: Data?, request: inout URLRequest) {
		if let bodyParameters = bodyParameters {
			try? JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
		}
		if let urlParameters = urlParameters {
			try? URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
		}
	}
	
	func cancel() {
		self.task?.cancel()
	}
}
