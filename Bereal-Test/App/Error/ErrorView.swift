//
//  ErrorView.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import SwiftUI

struct ErrorView: View {
    var errorWrapper: ErrorWrapper

    var body: some View {
        VStack {
            Text(errorWrapper.title)
            Text(errorWrapper.error.localizedDescription)
        }.padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorWrapper: ErrorWrapper(error: RequestError.invalidURL, title: "Invalid URL"))
    }
}
