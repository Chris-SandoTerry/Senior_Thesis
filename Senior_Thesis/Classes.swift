//
//  Classes.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 1/17/24.
//

import SwiftUI
import Firebase

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
            try await RosterAttempt.shared.addUserStudent(userId:user.userId,student: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
 
    
//    func loadRoster() {
//            Task {
//                do {
//                    self.user = try await UserManager.shared.(userId: authDataResult.uid)
//                } catch {
//                    print("Error loading roster: \(error)")
//                }
//            }
//        }
    
    func addUserStudentRoster() {
            guard let user = user else { return }
        let roster = Senior_Thesis.Professor(id: "", students: user.email ?? "", qrCode: user.scannedQr, isMatch: false)
            Task {
                do {
//                    try await UserManager.shared.addStudentRoster(userId: user.userId, student: roster)
                    //try await loadRoster()
                } catch {
                    print("Error adding user to roster: \(error)")
                    
                }
            }
        }
    func addUserToRoster() {
           Task {
               do {
                   
                   guard let user = self.user else {
                       return
                   }
                   
                   // Create a Firestore document representing the user
                   let userDocument = UserDocument(userId: user.userId, userName: "Chris", email: user.email ?? "",isMatch: false,dateCreated: Date(), ScannedQr: user.scannedQr ?? [""])
                   
                   // Add the user document to the "roster" collection in Firestore
                   let db = Firestore.firestore()
                   let userRef = db.collection("roster").document(user.userId)
                   try await userRef.setData(from: userDocument)
                   
                   // Refresh the user data after adding to the roster
                   self.user = try await UserManager.shared.getUser(userId: user.userId)
               } catch {
                   print("Error adding user to roster: \(error)")
                   // Handle error as needed
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
                    _professor.addUserToRoster()
                   
                } label: {
                    Text("Join Professor roster: \(user.email ?? "")")
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
