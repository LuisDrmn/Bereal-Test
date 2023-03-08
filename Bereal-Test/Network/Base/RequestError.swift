//
//  RequestError.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

enum RequestError: LocalizedError {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case forbidden
    case unexpectedStatusCode(statusCode: String)
    case unknown
    case emptyRequest
    case invalidData

    var errorDescription: String? {
        switch self {
        case .decode:
            return "Unable to decode data"
        case .unauthorized:
            return "Session expired"
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected Status Code: \(statusCode)"
        default:
            return "Unknown Error"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .decode:
            return "Try again later"
        default:
            return "Unknown Error"
        }
    }
}
