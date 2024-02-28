//
//  SignInEmailViewModel.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/28/24.
//

import Foundation

final class SignUpEmailViewModel: ObservableObject
{
    @Published var email = ""
    @Published var password = ""
    
    func signUp()async throws{
        guard !email.isEmpty, !password.isEmpty else
        {
            print("No email or password found.")
            return
        }
       let authDataResult = try await AuthentaticationManager.shared.createUser(email: email, password: password)
       try await UserManager.shared.createNewUser(auth: authDataResult)
        
        
    }
    
    
    func signIn()async throws{
        guard !email.isEmpty, !password.isEmpty else
        {
            print("No email or password found.")
            return
        }
       try await AuthentaticationManager.shared.signInUser(email: email, password: password)
        
        
    }
}
