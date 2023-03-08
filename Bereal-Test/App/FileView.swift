//
//  FileView.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import SwiftUI

struct FileView: View {
    @EnvironmentObject var errorState: ErrorState

    var item: Item
    @State private var data: Data?

    var body: some View {
        VStack {
            if item.contentType == "image/jpeg",
                let data = data,
                let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            }
            if item.contentType == "text/plain; charset=utf-8", let data = data {
                Text(String(data: data, encoding: .utf8) ?? "Error")
                    .padding()
            }
        }.task {
            do {
                self.data = try await BerealManager.shared.getData(of: item)
            } catch let error {
                errorState.errorWrapper = ErrorWrapper(error: error, title: "Couldn't present the file")
            }
        }
    }
}
