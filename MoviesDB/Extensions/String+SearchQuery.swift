//
//  String+SearchQuery.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import Foundation

extension String {
    var searchQuery: String {
        self.lowercased().trimmingCharacters(in: .whitespaces)
    }
}
