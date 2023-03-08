//
//  ErrorWrapper.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation

struct ErrorWrapper: Identifiable {
    var id: UUID = UUID()
    var error: Error
    var title: String
}
