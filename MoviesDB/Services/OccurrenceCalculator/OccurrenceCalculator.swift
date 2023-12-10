//
//  OccurrenceCalculator.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import Foundation

protocol OccurrenceCalculatorProtocol {
    func calculateOccurrence(of movie: Movie) -> [Occurrence]
}

final class OccurrenceCalculator: OccurrenceCalculatorProtocol {
    
    func calculateOccurrence(of movie: Movie) -> [Occurrence] {
        let title = movie.title.lowercased().filter( { !($0.isNumber && $0.isWhitespace) })
        
        var charactersDictionary = [Character: UInt]()
        
        for character in title {
            charactersDictionary[character, default: 0] += 1
        }
        
        let occurrences = charactersDictionary.map { Occurrence(char: $0.key, count: $0.value) }
            .sorted(by: { $0.count > $1.count })
        return occurrences
    }

}
