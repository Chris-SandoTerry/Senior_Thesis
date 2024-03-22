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
    @State private var qrCodeContent: String = ""
    
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
    
    func toggleQrCode() {
        guard let user else{return}
        let randomQrCode = QrCodePrompt()
        var newQrCode = randomQrCode.generateRandomString()
        //randomQrCode.generateQRCode(from: newQrCode)
        //_ = user.qrCode ?? "First Qr Code"
        Task{
            try await UserManager.shared.updateUserQRCode(userId: user.userId,qrCode: newQrCode)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
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
    
    struct ProfileView: View {
        
        @StateObject private var viewModel = ProfileViewModel()
        @Binding var showSingnedInView: Bool
        @State private var selection = 0
        @State private var isSettingsViewPresented = false
        
        
        var body: some View {
            TabView(selection: $selection) {
                List {
                    if let user = viewModel.user {
                        //Text("UserId: \(user.userId) ")
                        if let pfp = user.photoUrl
                        {
                            Image("SeniorPoject")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                        if let email = user.email {
                            Text("Email: \(email.description.capitalized)  ")
                        }
                        Button {
                            viewModel.toggleTeacherStatus()
                            viewModel.addUserProfessor(text:"Professor")
                        } label: {
                            Text("User is a Teacher: \((user.isTeacher ?? false).description.capitalized) ")
                        }
                        Button {
                            viewModel.toggleStudentStatus()
                            viewModel.addUserStudent(text:"Student")
                        } label: {
                            Text("User is a Student: \((user.isStudent ?? false).description.capitalized) ")
                        }
                        Button {
                            viewModel.toggleQrCode()
                        } label: {
                            Text("Qr Code \(user.qrCode ?? "Defualt Qr Code")" )
                        }
                      
                    }
                    
                }
                .task  {
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
                
                QrCodeImage()
                    .tabItem {
                        Image(systemName: "square.and.arrow.up.fill")
                        Text("Qr Code")
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
        NavigationStack{
            ProfileView(showSingnedInView: .constant(false))
        }
    }
    

