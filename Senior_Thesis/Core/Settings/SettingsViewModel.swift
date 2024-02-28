//
//  SettingsViewModel.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/28/24.
//

import Foundation

@MainActor
final class SettingsViewModel:ObservableObject
{
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let provider = try? AuthentaticationManager.shared.getProviders(){
            authProviders = provider
        }
    }
    
    func signOut() throws
    {
        try AuthentaticationManager.shared.signOut()
    }
    
    func resetPassword() async throws{
        let authUser = try AuthentaticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email
        else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthentaticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws
    {
        let email = "bruh@gmail.com"
        try await AuthentaticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws{
        let password = "hello123"
        try await AuthentaticationManager.shared.updatePassword(password: password)
    }
    
    func deleteAccount() async throws {
        try await AuthentaticationManager.shared.delete()
    }
}
