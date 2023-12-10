//
//  String+Error.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

extension String {
    func toError() -> Error {
        return NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : self]) as Error
    }
}
