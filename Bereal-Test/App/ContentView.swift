//
//  ContentView.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navViewModel = NavigationViewModel()
    @EnvironmentObject var errorState: ErrorState

    @State private var user: User?

    var body: some View {
        VStack {
            if let user = user {
                NavigationStack(path: $navViewModel.navigationPath) {
                    FolderView(folderId: user.rootItem.id, items: [user.rootItem])
                        .navigationDestination(for: Item.self, destination: { item in
                            if item.isDir {
                                FolderView(title: item.name, folderId: item.id , items: [])
                                    .environmentObject(errorState)
                                    .environmentObject(navViewModel)
                            } else {
                                FileView(item: item)
                                    .environmentObject(errorState)
                            }
                        })
                        .environmentObject(errorState)
                        .environmentObject(navViewModel)
                }
            } else {
                LoginView(didLogin: { user in
                    self.user = user
                }).environmentObject(errorState)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ErrorState())
    }
}
