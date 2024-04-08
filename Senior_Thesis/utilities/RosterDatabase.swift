//
//  RosterDatabase.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 4/1/24.
//

import Foundation
import Firebase

struct UserDocument: Decodable, Encodable {
    let userId: String
    let userName: String
    let email: String
    var isMatch: Bool
    let dateCreated: Date?
    let ScannedQr: [String]?
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case email = "email"
        case isMatch = "isMatch"
        case ScannedQr = "ScannedQr"
        case userName = "userName"
        case dateCreated
       
    }
}

//Professor->user(student)-> qr Code
struct Professor:  Identifiable {
    let id: String
    let students: String
    let qrCode: [String]?
    let isMatch: Bool?
}

final class RosterAttempt{
    
    static let shared = RosterAttempt()
    private init() { }
    private let userCollection = Firestore.firestore().collection("roster")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func addUserStudent(userId: String, student: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isStudents.rawValue : [student]
        ]
        try  await userDocument(userId: userId).updateData(data)
    }
    
}

class ViewModel: ObservableObject{

    @Published var list = [Professor]()


    func getAllUsers() {

        let db = Firestore.firestore()

        db.collection("roster").getDocuments { snapshot, error in

            if error == nil {
                if let snapshot = snapshot {
                    //update the list on the main thread
                    DispatchQueue.main.async {

                        self.list = snapshot.documents.map{ d in

                            return Professor(id: d.documentID, students: d["email"] as? String ?? "", qrCode: d["scannedQr"] as? [String] ?? [""], isMatch: d["isMatch"] as? Bool ?? false)
                        }
                    }


                }
            }
            else{

            }
        }


    }

}

