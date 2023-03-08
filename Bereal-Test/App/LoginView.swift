//
//  LoginView.swift
//  Bereal-Test
//
//  Created by Jean-Louis Darmon on 07/03/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var errorState: ErrorState
    @AppStorage("username") private var usernameDefault = ""
    @AppStorage("password") private var passwordDefault = ""

    var didLogin: ((User) -> Void)?

    var body: some View {
        VStack {
            Text("Welcome to the Bereal Test !")
                .font(.headline)
                .fontWeight(.bold)
            TextField("Username", text: $usernameDefault)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $passwordDefault)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            Button("Login") {
                Task {
                    do {
                        let user = try await BerealManager.shared.getMe()
                        didLogin?(user)
                    } catch let error {
                        errorState.errorWrapper = ErrorWrapper(error: error, title: "Error while trying to login")
                    }
                }
            }.buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
