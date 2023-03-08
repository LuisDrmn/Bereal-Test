//
//  BerealEndpoint.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

enum BerealEndpoint {
    case getMe
    case listFolder(id: String)
    case getData(id: String)
    case createFolder(name: String, id: String)
    case uploadFile(data: Data, name: String, id: String)
    case delete(id: String)
}

extension BerealEndpoint: Endpoint {

    var host: String {
        "163.172.147.216"
    }

    var port: Int? {
        8080
    }

    var path: String {
        switch self {
        case .getMe:
            return "/me"
        case .listFolder(let id), .createFolder(_, let id), .uploadFile(_, _, let id), .delete(let id):
            return "/items/\(id)"
        case .getData(let id):
            return "/items/\(id)/data"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getMe, .listFolder, .getData:
            return .get
        case .createFolder, .uploadFile:
            return .post
        case .delete:
            return .delete
        }
    }

    var urlQueryItems: [URLQueryItem]? {
        nil
    }

    var header: [String : String]? {
        let defaults = UserDefaults.standard
        guard let username = defaults.string(forKey: "username"),
              let password = defaults.string(forKey: "password"),
              let authData = (username + ":" + password).data(using: .utf8)?.base64EncodedString() else {
            return nil
        }
        var baseHeader = ["Authorization":"Basic \(authData)"]

        switch self {
        case .getMe, .listFolder, .delete, .getData:
            return baseHeader
        case .createFolder(_, _):
            baseHeader["Content-Type"] = "application/json"
            return baseHeader
        case .uploadFile(_, let name, _):
            baseHeader["Content-Type"] = "application/octet-stream"
            baseHeader["Content-Disposition"] = "attachment; filename=\"\(name)\"; filename*=utf-8''\(name)"
            return baseHeader
        }
    }

    var jsonBody: [String : String]? {
        switch self {
        case .getMe, .listFolder, .uploadFile, .delete, .getData:
            return nil
        case .createFolder(let name, _):
            return ["name": name]
        }
    }

    var dataBody: Data? {
        switch self {
        case .getMe, .listFolder, .getData, .createFolder, .delete:
            return nil
        case .uploadFile(let data, _, _):
            return data
        }
    }
}
