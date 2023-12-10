//
//  Dispatch+ExecuteOnMain.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation

extension DispatchQueue {
    static func executeOnMain(_ handler: @escaping () -> Void) {
        if Thread.isMainThread {
            handler()
        } else {
            DispatchQueue.main.async {
                handler()
            }
        }
    }
}
