//
//  HTTPClient.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Codable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T?, RequestError>
}

extension HTTPClient {
    private func makeNetworkRequest(with endpoint: Endpoint) -> Result<URLRequest, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.port = endpoint.port
        urlComponents.path = endpoint.path
        if let urlQueryItems = endpoint.urlQueryItems {
            urlComponents.queryItems = urlQueryItems
        }

        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        if let jsonBody = endpoint.jsonBody {
            request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)
        }
        if let dataBody = endpoint.dataBody {
            request.httpBody = dataBody
        }
        return .success(request)
    }

    func sendRequest<T: Codable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T?, RequestError> {
        var request: URLRequest?

        let result = makeNetworkRequest(with: endpoint)

        switch result {
        case .success(let networkRequest):
            request = networkRequest
        case .failure(let error):
            return .failure(error)
        }
        guard let request = request else {
            return .failure(.emptyRequest)
        }

        do {
            let (urlSessionData, urlSessionResponse) = try await URLSession.shared.data(for: request)
            guard let response = urlSessionResponse as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                if urlSessionData.isEmpty {
                    return .success(nil)
                }

                if urlSessionResponse.mimeType == "application/json" {
                    guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: urlSessionData) else {
                        return .failure(.decode)
                    }
                    return .success(decodedResponse)
                } else {
                    guard let data = urlSessionData as? T else {
                        return .failure(.invalidData)
                     }
                    return .success(data)
                }
            case 401:
                return .failure(.unauthorized)
            case 403:
                return .failure(.forbidden)
            default:
                return .failure(.unexpectedStatusCode(statusCode: String(response.statusCode)))
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
