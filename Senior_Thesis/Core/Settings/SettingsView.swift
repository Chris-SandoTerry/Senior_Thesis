//
//  SettingsView.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/21/24.
//

import SwiftUI



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
            
            Button(role: .destructive){
                Task
                {
                    do
                    {
                        try await viewModel.deleteAccount()
                        showSignedInView = true
                    }catch
                    {
                        print(error)
                    }
                }
            }label: {
                Text("Delete Acount")
            }
            
            
            if viewModel.authProviders.contains(.email){
                emailSection
            }
            
        }
        .onAppear{
            viewModel.loadAuthProviders()
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
