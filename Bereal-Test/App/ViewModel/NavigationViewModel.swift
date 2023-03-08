//
//  NavigationViewModel.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import Foundation
import SwiftUI

class NavigationViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()

    func navigateTo(item: Item) {
        navigationPath.append(item)
    }

    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
}
