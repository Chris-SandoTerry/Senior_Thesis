//
//  AuthentaticationManager.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/20/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel
{
    let uid: String
    let email: String?
    let photoUrl: String?
    
    
    init(user:User)
    {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String{
    case email = "password"
    case google = "google.com"
}


final class AuthentaticationManager
{
    static let shared = AuthentaticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel
    {
        guard let user = Auth.auth().currentUser else
        {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func getProviders () throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else{
            throw URLError(.badServerResponse)
        }
        var providers: [AuthProviderOption] = []
        for provider in providerData{
            if let option = AuthProviderOption(rawValue: provider.providerID){
                providers.append(option)
            }else
            {
                assertionFailure("Provider Option Not Found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badURL)
        }
        try await user.delete()
    }

    
    
}

//SIGN IN EMAIL
extension AuthentaticationManager{
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
       let authDataresult = try await Auth.auth().createUser(withEmail: email, password: password)
       return AuthDataResultModel(user: authDataresult.user)
    }
    
    
    func resetPassword(email:String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String)async throws {
        guard let user = Auth.auth().currentUser else
        {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String)async throws {
        guard let user = Auth.auth().currentUser else
        {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataresult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataresult.user)
    }
    
}

//SIGN IN SSO
extension AuthentaticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel)  async throws -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
                                                       accessToken: tokens.accessToken)

        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential)  async throws -> AuthDataResultModel{
       
        let authDataresult =  try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataresult.user)
    }
}

