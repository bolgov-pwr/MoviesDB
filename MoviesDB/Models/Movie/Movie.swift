//
//  Movie.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import Foundation
import CoreData

struct Movie: Decodable {

    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double?

    init(id: Int, title: String, posterPath: String? = nil, voteAverage: Double? = nil) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.voteAverage = voteAverage
    }
    
    init(from entity: MovieEntity) {
        self.init(id: entity.id, title: entity.title, posterPath: entity.imagePath, voteAverage: entity.rating)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}

extension Movie: Equatable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
