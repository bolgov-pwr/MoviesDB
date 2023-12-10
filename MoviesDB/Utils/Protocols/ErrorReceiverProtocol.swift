//
//  ErrorReceiverProtocol.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

protocol ErrorReceiverProtocol: AnyObject {
    func didReceive(error: Error)
}
