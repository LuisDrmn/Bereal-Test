//
//  CreateFolderView.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 08/03/2023.
//

import SwiftUI

struct CreateFolderView: View {
    @EnvironmentObject var errorState: ErrorState
    @EnvironmentObject var navViewModel: NavigationViewModel
    @State private var presentFolderAlert: Bool = false
    @State private var folderName: String = ""

    var folderId: String

    var body: some View {
        Button {
            presentFolderAlert = true
        } label: {
            Image(systemName: "folder.badge.plus")
        }.alert("Create Folder", isPresented: $presentFolderAlert) {
            TextField("Folder Name", text: $folderName)
            Button("Create", action: {
                Task {
                    if let newFolder = await createFolder(with: folderName) {
                        navViewModel.navigateTo(item: newFolder)
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {
                presentFolderAlert = false
            })
        }
    }

    private func createFolder(with name: String) async -> Item? {
        do {
            let newFolderItem = try await BerealManager.shared.createFolder(with: name, in: folderId)
            return newFolderItem
        } catch let error {
            errorState.errorWrapper = ErrorWrapper(error: error, title: "Error while trying to create a folder")
            return nil
        }
    }
}

struct CreateFolderView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFolderView(folderId: UUID().uuidString)
    }
}
