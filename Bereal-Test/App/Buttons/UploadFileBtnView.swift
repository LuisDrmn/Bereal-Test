//
//  UploadFileBtnView.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 08/03/2023.
//

import SwiftUI

struct UploadFileBtnView: View {
    @EnvironmentObject var errorState: ErrorState
    @EnvironmentObject var navViewModel: NavigationViewModel
    @State private var presentFileImporter: Bool = false

    var folderId: String
    var body: some View {
        Button {
            presentFileImporter = true
        } label: {
            Image(systemName: "doc.fill.badge.plus")
        }.fileImporter(isPresented: $presentFileImporter, allowedContentTypes: [.image, .text]) { result in
            do {
                let fileUrl = try result.get()
                uploadFile(fileUrl)
            } catch {
                errorState.errorWrapper = ErrorWrapper(error: error, title: "Error uploading file")
            }
        }
    }

    private func uploadFile(_ fileUrl: URL) {
        do {
            print(fileUrl.lastPathComponent)
            if fileUrl.startAccessingSecurityScopedResource() {
                let fileData = try Data(contentsOf: fileUrl)
                Task {
                    let item = try await BerealManager.shared.uploadFile(with: fileData, name: fileUrl.lastPathComponent, in: folderId)
                    navViewModel.navigateTo(item: item)
                }
            }
            fileUrl.stopAccessingSecurityScopedResource()
        } catch {
            errorState.errorWrapper = ErrorWrapper(error: error, title: "Error uploading file")
        }
    }
}

struct UploadFileBtnView_Previews: PreviewProvider {
    static var previews: some View {
        UploadFileBtnView(folderId: UUID().uuidString)
    }
}
