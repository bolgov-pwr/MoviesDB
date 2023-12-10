//
//  MoviesResponse.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movie]
}
