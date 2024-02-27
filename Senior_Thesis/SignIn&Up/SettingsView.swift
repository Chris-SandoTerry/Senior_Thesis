//
//  SettingsView.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/21/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel:ObservableObject
{
    
    
    
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
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignedInView: Bool
    
    
    var body: some View {
        
        List
        {
            Button("Logout")
            {
                Task
                {
                    do
                    {
                        try viewModel.signOut()
                        showSignedInView = true
                    }catch
                    {
                        print(error)
                    }
                }
                
            }
            emailSection
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    SettingsView(showSignedInView: .constant(false))
}

extension SettingsView{
    
    private var emailSection: some View{
        Section {
            Button("Reset Password")
            {
                Task
                {
                    do
                    {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET")
                        //for these functions instruct them to login and then prompt a screen for them to enter it
                    }catch
                    {
                        print(error)
                    }
                }
                
            }
            Button("Update Password")
            {
                Task
                {
                    do
                    {
                        try await viewModel.updatePassword()
                        print("PASSWORD UPDATED")
                    }catch
                    {
                        print(error)
                    }
                }
                
            }
            Button("Update Email")
            {
                Task
                {
                    do
                    {
                        try await viewModel.updateEmail()
                        print("EMAIL UPDATED")
                    }catch
                    {
                        print(error)
                    }
                }
                
            }


        }
        header: {
            Text("Email functions")
        }
    }
}
