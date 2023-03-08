//
//  BerealManager.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

enum BerealManagerError: LocalizedError {
    case resultIsNil

    var errorDescription: String? {
        switch self {
        case .resultIsNil:
            return "API returned empty data where it should not"
        }
    }
}

class BerealManager {
    static let shared = BerealManager()
    private var berealService: BerealService = BerealService()

    func getMe() async throws -> User {
        let result = await berealService.getMe()
        switch result {
        case .success(let user):
            guard let user = user else {
                throw BerealManagerError.resultIsNil
            }
            return user
        case .failure(let error):
            throw error
        }
    }

    func getData(of item: Item) async throws -> Data {
        let result = await berealService.getData(of: item.id)

        switch result {
        case .success(let data):
            guard let data = data else {
                throw BerealManagerError.resultIsNil
            }
            return data
        case .failure(let error):
            throw error
        }

    }

    func getContent(of id: String) async throws -> [Item] {
        let result = await berealService.getContent(of: id)
        switch result {
        case .success(let items):
            guard let items = items else {
                throw BerealManagerError.resultIsNil
            }
            return items
        case .failure(let error):
            throw error
        }
    }

    func createFolder(with name: String, in id: String) async throws -> Item {
        let result = await berealService.createFolder(with: name, in: id)
        switch result {
        case .success(let item):
            guard let item = item else {
                throw BerealManagerError.resultIsNil
            }
            return item
        case .failure(let error):
            throw error
        }
    }

    @discardableResult
    func uploadFile(with data: Data, name: String, in id: String) async throws -> Item {
        let result = await berealService.uploadFile(with: data, name: name, in: id)
        switch result {
        case .success(let item):
            guard let item = item else {
                throw BerealManagerError.resultIsNil
            }
            return item
        case .failure(let error):
            throw error
        }
    }

    func delete(item: Item) async throws {
        if item.isDir {
            let items = try await getContent(of: item.id)
            for item in items {
                try await delete(item: item)
            }
        }

        let result = await berealService.delete(id: item.id)
        switch result {
        case .success:
            break
        case .failure(let error):
            throw error
        }
    }
}
