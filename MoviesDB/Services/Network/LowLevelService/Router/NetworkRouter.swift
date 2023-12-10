//
//  NetworkRouter.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 09.12.2023.
//

import Foundation
typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()
typealias NetworkRouterResult = (data: Data?, response: URLResponse?, error: Error?)

protocol NetworkRouter: AnyObject  {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
}
