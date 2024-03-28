//
//  Classes.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 1/17/24.
//

import SwiftUI

@MainActor
final class ClassesViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var Professor: Professor? = nil
    @Published private(set) var roster: [Professor] = []
    
    
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
    
 
    
    func loadRoster() {
            Task {
                do {
                    self.roster = try await UserManager.shared.getRoster()
                } catch {
                    print("Error loading roster: \(error)")
                }
            }
        }
    
    func addUserStudentRoster() {
            guard let user = user else { return }
        let roster = Senior_Thesis.Professor(students: user.email ?? "", qrCode: user.scannedQr, isMatch: false)
            Task {
                do {
                    try await UserManager.shared.addStudentRoster(userId: user.userId, student: roster)
                    //try await loadRoster()
                } catch {
                    print("Error adding user to roster: \(error)")
                    // Handle error as needed, e.g., show an alert to the user
                }
            }
        }
}

struct Classes: View {
    let _class = classlist
    @StateObject private var _professor = ClassesViewModel()
    
    var body: some View {
        List(_class, id: \.self) 
        { _class in
            NavigationLink(destination: Text(_class)) 
            {
                Image(systemName: "folder.fill")
                Text(_class)
            }
            if let user = _professor.user {
                Button {
                        _professor.addUserStudentRoster()
                   
                } label: {
                    Text("Join Professor roster: \(user.roster?.students ?? "")")
             }
           }
             
         }
        .task {
             try? await _professor.loadcurrentUser()
             }
             .navigationTitle("Classes")
         }
        }
      

   



#Preview {
    Classes()
}
