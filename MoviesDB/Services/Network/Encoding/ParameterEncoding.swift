//
//  ParameterEncoding.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation
public typealias Parameters = [String:Any]
protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameter encoding fail"
    case missingURL = "URL is nil."
}
