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
    
}

struct StudentProfile: View {
    @State private var selection = 0
    @State private var showloginscreen = false
    @Binding var showSingnedInView: Bool
    @StateObject private var viewModel = StudentViewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                VStack(spacing: 20) {
                    let user = viewModel.user
                    Image("SeniorPoject")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    if let email = user?.email {
                        Text("Email: \(email.description.capitalized)  ")
                    }
                    
                    Text("Student")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    
                    Divider()
                    

                    Spacer()
                    
                }
                .padding()
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

            QrCodeImage()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Qr Code")
                }
                .tag(2)
            
            
        }
    }
}

#Preview {
    StudentProfile(showSingnedInView: .constant(false))
}
