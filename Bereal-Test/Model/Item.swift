//
//  Item.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

struct Item: Codable, Identifiable, Hashable {
    let id, parentId, name: String
    let isDir: Bool
    let modificationDate: String
    let size: Int?
    let contentType: String?
}
