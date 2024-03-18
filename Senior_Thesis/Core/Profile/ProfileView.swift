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
        let currentQrCode = QrCodePrompt(onQRCodeGenerated: { content in
            self.qrCodeContent = content
            //let randomQrCode = QrCodePrompt()
            // var newQrCode = randomQrCode.generateRandomString() ?? "First Qr Code"
            //randomQrCode.generateQRCode(from: newQrCode)
            //_ = user.qrCode ?? "First Qr Code"
            Task{
                try await UserManager.shared.updateUserQRCode(userId: user.userId,qrCode: content)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            }
        })
        
    }
        
    }
    
    struct ProfileView: View {
        
        @StateObject private var viewModel = ProfileViewModel()
        @Binding var showSingnedInView: Bool
        @State private var selection = 0
        
        
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
                        } label: {
                            Text("User is a Teacher: \((user.isTeacher ?? false).description.capitalized) ")
                        }
                        Button {
                            viewModel.toggleStudentStatus()
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
        NavigationStack{
            ProfileView(showSingnedInView: .constant(false))
        }
    }

