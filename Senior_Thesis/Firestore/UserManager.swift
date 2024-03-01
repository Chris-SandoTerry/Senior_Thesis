//
//  UserManager.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isTeacher: Bool?
    let isStudent: Bool?
    
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isTeacher = false
        self.isStudent = false
    }
    
    init (
        userId: String,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date?,
        isTeacher: Bool? = nil,
        isStudent: Bool? = nil
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isTeacher = isTeacher
        self.isStudent = isStudent
    }
//    
//    func toggleTeahcerStatus() -> DBUser{
//        let currentValue = isTeacher ?? false
//        return DBUser(
//            userId: userId,
//            email: email,
//            photoUrl: photoUrl,
//            dateCreated: dateCreated,
//            isTeacher: !currentValue,
//            isStudent: isStudent)
//    }
//    
//    mutating func toggleTeahcerStatus() {
//        let currentValue = isTeacher ?? false
//        isTeacher = !currentValue
//    }
//    
//    func toggleStudentStatus() -> DBUser {
//        let currentValue = isStudent ?? false
//        return DBUser(
//            userId: userId,
//            email: email,
//            photoUrl: photoUrl,
//            dataCreated: dataCreated,
//            isTeacher: isTeacher,
//            isStudent: !currentValue)
//    }
    
//    mutating func toggleStudentStatus() {
//        let currentValue = isStudent ?? false
//        isStudent = !currentValue
//    }
//    
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "data_created"
        case isTeacher = "is_teacher"
        case isStudent = "is_student"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isTeacher = try container.decodeIfPresent(Bool.self, forKey: .isTeacher)
        self.isStudent = try container.decodeIfPresent(Bool.self, forKey: .isStudent)
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isTeacher, forKey: .isTeacher)
        try container.encodeIfPresent(self.isStudent, forKey: .isStudent)
    }
    
  
    
   
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
//    private let encoder: Firestore.Encoder = {
//        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        return encoder
//    }()
//    
//    private let decoder: Firestore.Decoder = {
//        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return decoder
//    }()
    
    
    
    func createNewUser(user: DBUser) async throws {
      try  userDocument(userId: user.userId).setData(from: user, merge: false)
   }
//    
//    func createNewUser(auth: AuthDataResultModel) async throws {
//        var userData: [String:Any] = [
//            "user_id" : auth.uid,
//            "date_created": Timestamp(),
//            
//        ]
//        if let email = auth.email{
//            userData["email"] = email
//        }
//        if let PhotoUrl = auth.photoUrl {
//            userData["photo_"] = PhotoUrl
//        }
//        
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//    }
    
    
    func getUser(userId: String) async throws -> DBUser {
         try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    
    
//    func getUser(userId: String) async throws -> DBUser {
//        
//        let snapshot = try await userDocument(userId: userId).getDocument()
//        
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let dataCreated = data["date_created"] as? Date
//        
//        
//        return DBUser(userId: userId, email: email, photoUrl: photoUrl, dataCreated: dataCreated)
//    }
    
    
//    func updatedUserTeacherStatus(user: DBUser) async throws{
//        try userDocument(userId: user.userId).setData(from: user, merge: true)
//    }
//    
    
    func updateUserTeacherStatus(userId: String,isTeacher: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isTeacher.rawValue : isTeacher
        ]
        try  await userDocument(userId: userId).updateData(data)
    }
    
//    func updatedUserStudentStatus(user: DBUser) async throws{
//        try userDocument(userId: user.userId).setData(from: user, merge: true)
//    }
    
    
    func updateUserStudentStatus(userId: String,isStudent: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isStudent.rawValue : isStudent
        ]
        try  await userDocument(userId: userId).updateData(data)
    }
}
