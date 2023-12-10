//
//  URLSession.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

extension URLSession: URLSessionProtocol {
	func dataTask(with request: URLRequest, path: String, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
		return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
	}
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
