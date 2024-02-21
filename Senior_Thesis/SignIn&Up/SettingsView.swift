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
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    SettingsView(showSignedInView: .constant(false))
}
