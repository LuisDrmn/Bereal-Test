//
//  User.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

struct User: Codable {
    let firstName, lastName: String
    let rootItem: Item
}
