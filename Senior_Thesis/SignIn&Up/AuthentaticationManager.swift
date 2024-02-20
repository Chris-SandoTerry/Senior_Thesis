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

final class AuthentaticationManager
{
    static let shared = AuthentaticationManager()
    private init() { }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
       let authDataresult = try await Auth.auth().createUser(withEmail: email, password: password)
       return AuthDataResultModel(user: authDataresult.user)
    }
}
