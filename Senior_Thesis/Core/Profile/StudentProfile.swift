//
//  ProfessorProfile.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 1/19/24.
//

import Foundation
import SwiftUI
import MapKit

@MainActor
final class StudentViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadcurrentUser() async throws {
        let authDataResult = try  AuthentaticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func toggleTeacherStatus() {
        guard let user else {return}
        let currentValue = user.isTeacher ?? false
        Task {
            try await UserManager.shared.updateUserTeacherStatus(userId: user.userId,isTeacher:!currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func toggleStudentStatus() {
        guard let user else {return}
        let currentValue = user.isStudent ?? false
        Task {
            try await UserManager.shared.updateUserStudentStatus(userId: user.userId,isStudent: !currentValue)
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

struct StudentProfile: View {
    @State private var selection = 0
    @State private var showloginscreen = false
    @Binding var showSingnedInView: Bool
    @StateObject private var viewModel = StudentViewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            List {
                Text("Student")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                if let user = viewModel.user{
                    if let name = user.userName {
                        Text("\(name.description.capitalized) ")
                    }
                    
                   

                }
            }
            .task {
                try? await viewModel.loadcurrentUser()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(0)
            
            Classes()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Classes")
                }
                .tag(1)
            
            CameraViewDemo()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Scan Qr")
                }
                .tag(2)
            SettingsView(showSignedInView: $showSingnedInView)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)
            
            
        }
    }
}

#Preview {
    StudentProfile(showSingnedInView: .constant(false))
}
