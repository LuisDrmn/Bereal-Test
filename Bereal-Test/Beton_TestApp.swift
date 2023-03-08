//
//  Bereal_TestApp.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import SwiftUI

@main
struct Bereal_TestApp: App {
    @StateObject private var errorState = ErrorState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(errorState)
                .sheet(item: $errorState.errorWrapper) { errorWrapper in
                    ErrorView(errorWrapper: errorWrapper)
                }
        }
    }
}
