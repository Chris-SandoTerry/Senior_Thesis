//
//  ProfileView.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/28/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadcurrentUser() async throws {
        let authDataResult = try  AuthentaticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSingnedInView: Bool
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserId: \(user.userId) ")
                
                if let email = user.email {
                    Text("Email: \(email.description.capitalized)  ")
                }
            }
           
        }
        .task  {
            try? await viewModel.loadcurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignedInView: $showSingnedInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }

            }
        }
    }
}

#Preview {
    NavigationStack{
        ProfileView(showSingnedInView: .constant(false))
    }
}
