//
//  UserManager.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String:Any] = [
            "user_id" : auth.uid,
            "date_created": Timestamp(),
            
            
        ]
        if let email = auth.email{
            userData["email"] = email
        }
        if let PhotoUrl = auth.photoUrl {
            userData["photo_"] = PhotoUrl
        }
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
}
