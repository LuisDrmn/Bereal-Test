//
//  Endpoint.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var method: RequestMethod { get }
    var urlQueryItems: [URLQueryItem]? { get }
    var header: [String: String]? { get }
    var jsonBody: [String: String]? { get }
    var dataBody: Data? { get }
}

extension Endpoint {
    var scheme: String {
        "http"
    }
}
