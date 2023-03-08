//
//  BerealService.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

protocol BerealServiceable {
    func getMe() async -> Result<User?, RequestError>
    func getData(of id: String) async -> Result<Data?, RequestError>
    func getContent(of id: String) async -> Result<[Item]?, RequestError>
    func createFolder(with name: String, in id: String) async -> Result<Item?, RequestError>
    func uploadFile(with data: Data, name: String, in id: String) async -> Result<Item?, RequestError>
    func delete(id: String) async -> Result<Bool?, RequestError>
}

struct BerealService: HTTPClient, BerealServiceable {

    func getMe() async -> Result<User?, RequestError> {
        await sendRequest(endpoint: BerealEndpoint.getMe, responseModel: User.self)
    }

    func getData(of id: String) async -> Result<Data?, RequestError> {
        await sendRequest(endpoint: BerealEndpoint.getData(id: id), responseModel: Data.self)
    }

    func getContent(of id: String) async -> Result<[Item]?, RequestError> {
        await sendRequest(endpoint: BerealEndpoint.listFolder(id: id), responseModel: [Item].self)
    }

    func createFolder(with name: String, in id: String) async -> Result<Item?, RequestError> {
        await sendRequest(endpoint: BerealEndpoint.createFolder(name: name, id: id), responseModel: Item.self)
    }

    func uploadFile(with data: Data, name: String, in id: String) async -> Result<Item?, RequestError> {
        await sendRequest(endpoint: BerealEndpoint.uploadFile(data: data, name: name, id: id), responseModel: Item.self)
    }

    func delete(id: String) async -> Result<Bool?, RequestError> {
        await sendRequest(endpoint: BerealEndpoint.delete(id: id), responseModel: Bool.self)
    }
}
