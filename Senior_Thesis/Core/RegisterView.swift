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
    
    func loadcurrentUser() async throws {
        let authDataResult = try  AuthentaticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
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
    
    func addUserProfessor(text: String) {
        guard let user else{ return }
        
        Task {
            try await UserManager.shared.addUserProfessor(userId: user.userId, professor: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func addUserStudent(text: String) {
        guard let user else{ return }
        
        Task {
            try await UserManager.shared.addUserStudent(userId:user.userId,student: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Binding var showSingnedInView: Bool
    @State private var selection = 0
    @State private var isProfileViewPresented = false
    @State private var isStudentProfilePresented = false
    
    var body: some View {
        TabView(selection: $selection) {
            List {
                if let user = viewModel.user {
                    if let email = user.email {
                        Text("Email: \(email.description.capitalized)")
                    }
                    
                    Button {
                        viewModel.toggleTeacherStatus()
                        viewModel.addUserProfessor(text: "Professor")
                        isProfileViewPresented = true
                    } label: {
                        Text("User is: Professor")
                    }
                    
                    Button {
                        viewModel.toggleStudentStatus()
                        viewModel.addUserStudent(text: "Student")
                        isStudentProfilePresented = true
                    } label: {
                        Text("User is: Student")
                    }
                }
            }
            .task {
                try? await viewModel.loadcurrentUser()
            }
        }
        .fullScreenCover(isPresented: $isProfileViewPresented) {
            ProfileView(showSingnedInView: $showSingnedInView)
        }
        .fullScreenCover(isPresented: $isStudentProfilePresented) {
            StudentProfile(showSingnedInView: $showSingnedInView)
        }
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(showSingnedInView: .constant(false))
    }
}
