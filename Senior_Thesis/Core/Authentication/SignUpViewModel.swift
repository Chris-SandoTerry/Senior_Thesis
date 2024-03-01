//
//  SignUpViewModel.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/28/24.
//

import Foundation

@MainActor
final class SignUpViewModel: ObservableObject{
    
    func SignInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthentaticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        //try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
