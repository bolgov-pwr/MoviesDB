//
//  StateUpdaterProtocol.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

protocol StateUpdaterProtocol: AnyObject {
    func performUpdates(delete: [Int], insert: [Int])
}
