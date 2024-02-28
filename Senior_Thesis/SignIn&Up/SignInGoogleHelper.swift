//
//  SignInGoogleHelper.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/27/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift


struct GoogleSignInResultModel{
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
    //future addittion photo
}

final class SignInGoogleHelper{
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.badServerResponse)
        }
       
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else{
            throw URLError(.badServerResponse)
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
}
