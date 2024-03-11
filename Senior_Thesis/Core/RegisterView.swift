//
//  RegisterView.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 11/13/23.
//

import Foundation
import SwiftUI

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    
    func toggleTeacherStatus() {
        guard let user = user else { return }
        let currentValue = user.isTeacher ?? false
        Task {
            do {
                try await UserManager.shared.updateUserTeacherStatus(userId: user.userId, isTeacher: !currentValue)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            } catch {
                print("Error updating user teacher status: \(error)")
            }
        }
    }
    
    func toggleStudentStatus() {
        guard let user = user else { return }
        let currentValue = user.isStudent ?? false
        Task {
            do {
                try await UserManager.shared.updateUserStudentStatus(userId: user.userId, isStudent: !currentValue)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            } catch {
                print("Error updating user student status: \(error)")
            }
        }
    }
}

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Binding var showSingnedInView: Bool
    @State private var selection = 0
    @State private var isProfileViewPresented = false // New state variable to track if ProfileView should be presented
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                if let user = viewModel.user {
                    VStack {
                        Button {
                            viewModel.toggleTeacherStatus()
                            isProfileViewPresented = true // Present ProfileView after toggling status
                        } label: {
                            Text("User is a Teacher: \((user.isTeacher ?? false).description.capitalized) ")
                        }
                        .padding()
                        
                        NavigationLink(destination: ProfileView(showSingnedInView: $showSingnedInView).navigationBarBackButtonHidden(true), isActive: $isProfileViewPresented) {
                            EmptyView() // Use NavigationLink for programmatic navigation
                        }
                        
                        Button {
                            viewModel.toggleStudentStatus()
                            isProfileViewPresented = true // Present ProfileView after toggling status
                        } label: {
                            Text("User is a Student: \((user.isStudent ?? false).description.capitalized) ")
                        }
                        .padding()
                        
                        NavigationLink(destination: ProfileView(showSingnedInView: $showSingnedInView).navigationBarBackButtonHidden(true), isActive: $isProfileViewPresented) {
                            EmptyView() // Use NavigationLink for programmatic navigation
                        }
                    }
//                    .task {
//                        try? await viewModel.loadcurrentUser()
//                    }
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(showSingnedInView: .constant(false))
    }
}
