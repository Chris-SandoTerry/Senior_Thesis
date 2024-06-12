import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var roster: UserDocument?  = nil

   
    
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
        // Load single roster data from Firestore
        Task {
            do {
                let rosterData = try await UserManager.shared.getRosterData()
                guard let user = user, let currentUserQRCode = user.qrCode else {
                    // User or user's QR code is nil, cannot compare, so return
                    return
                }

                if let singleUserDocument = rosterData.first {
                    // Combine elements of ScannedQr array into a single string
                    let scannedQRString = singleUserDocument.ScannedQr?.joined(separator: "")
                    // Access the most recent element in the array
                    let mostRecentScannedQR = singleUserDocument.ScannedQr?.last ?? ""
                    
                    print("Scanned QR Code (Combined): \(scannedQRString ?? "error")")
                    print("Most Recent Scanned QR Code: \(mostRecentScannedQR)")

                    let isMatch = currentUserQRCode.contains { $0 == mostRecentScannedQR }

                    // Update isMatch property and roster
                    var updatedDocument = singleUserDocument
                    updatedDocument.isMatch = isMatch
                    self.roster = updatedDocument
                } else {
                   
                    self.roster = nil
                }
                
                self.objectWillChange.send()
            } catch {
                print("Error loading roster: \(error)")
               
            }
        }
    }
    
   



  
}
    
struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @ObservedObject var model = ViewModel()
    @Binding var showSingnedInView: Bool
    @State private var selection = 0
    @State private var isSettingsViewPresented = false
     
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current // Set the time zone to current
        return formatter.string(from: date)
    }
    
    
    var body: some View {
        TabView(selection: $selection) {
            List {
                
                Section(header: Text("Professor")) {
                              if let user = viewModel.user, let name = user.userName {
                                  Text("\(name.capitalized)")
                                      .foregroundColor(.blue)
                              } else {
                                  Text("No professor data available")
                                      .foregroundColor(.red)
                              }
                          }
                    
                    Section(header: Text("Roster")) {
                                   if let userDocument = viewModel.roster {
                                       // Display username and dateCreated
                                       VStack(alignment: .leading) {
                                           Text("\(userDocument.userName)")
                                           if let dateCreated = userDocument.dateCreated {
                                               Text("\(formattedDate(date: dateCreated))")
                                           } else {
                                               Text("Time scanned: N/A")
                                           }
                                       }
                                       .foregroundColor(userDocument.isMatch ? .green : .black)
                                   } else {
                                       Text("No roster data available")
                                   }
                               }
                
                
              
                
            }
            .task  {
                try? await viewModel.loadcurrentUser()
                viewModel.loadRoster()
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
    


