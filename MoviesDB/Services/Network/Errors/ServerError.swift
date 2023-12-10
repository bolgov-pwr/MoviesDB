//
//  ServerError.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

enum ServerError: Error {
    case canNotParseData
    
    // simplified init
    init(stringValue: String) {
        self = .canNotParseData
    }
}

extension ServerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .canNotParseData:
            return "Can not parse data"
        }
    }
}
