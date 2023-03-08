//
//  FolderView.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import SwiftUI

struct FolderView: View {
    @EnvironmentObject var errorState: ErrorState
    @EnvironmentObject var navViewModel: NavigationViewModel

    var title: String?
    var folderId: String
    @State var items: [Item]

    var body: some View {
        List(items) { item in
            HStack {
                Image(systemName: item.isDir ? "folder" : "doc")
                NavigationLink(item.name, value: item)
            }
            .swipeActions(allowsFullSwipe: false) {
                Button(role: .destructive) {
                    Task {
                        await delete(item: item)
                    }
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
        }
        .navigationTitle(title ?? "root")
        .toolbar {
            UploadFileBtnView(folderId: folderId)
                .environmentObject(errorState)
                .environmentObject(navViewModel)
            CreateFolderView(folderId: folderId)
                .environmentObject(errorState)
                .environmentObject(navViewModel)
        }
        .task {
            await fetchContent()
        }
    }

    private func fetchContent() async {
        do {
            self.items = try await BerealManager.shared.getContent(of: folderId)
        } catch let error {
            errorState.errorWrapper = ErrorWrapper(error: error, title: "Error while trying to get content of folder")
        }
    }

    private func delete(item: Item) async {
        do {
            try await BerealManager.shared.delete(item: item)
        } catch let error {
            errorState.errorWrapper = ErrorWrapper(error: error, title: "Error while trying to get delete \(item.name)")
        }
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(folderId: "asasas", items: [])
            .environmentObject(ErrorState())
    }
}
