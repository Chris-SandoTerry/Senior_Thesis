//
//  UserManager.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

//Professor->user(student)-> qr Code
struct Professor: Codable, Hashable{
    let students: String
    let qrCode: [String]?
    let isMatch: Bool?
}

struct DBUser: Codable {
    
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isProfessors:[String]?
    let isStudents:[String]?
    let isTeacher: Bool?
    let isStudent: Bool?
    let qrCode: [String]?
    let scannedQr: [String]?
    let roster: Professor?
    
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isTeacher = false
        self.isStudent = false
        self.qrCode = [auth.uid]
        self.isProfessors = [auth.uid]
        self.isStudents = [auth.uid]
        self.scannedQr = [auth.uid]
        self.roster = nil
    }
    
    init (
        userId: String,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date?,
        isTeacher: Bool? = nil,
        isStudent: Bool? = nil,
        qrCode: [String]?,
        isProfessors: [String]?,
        isStudents: [String]?,
        scannedQr: [String]?,
        roster: Professor? = nil
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isTeacher = isTeacher
        self.isStudent = isStudent
        self.qrCode = qrCode
        self.isProfessors = isProfessors
        self.isStudents = isStudents
        self.scannedQr = scannedQr
        self.roster = roster
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "data_created"
        case isTeacher = "is_teacher"
        case isStudent = "is_student"
        case qrCode = "qrCode"
        case isProfessors = "Professors"
        case isStudents = "Students"
        case scannedQr = "ScannedQr"
        case roster = "roster"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isTeacher = try container.decodeIfPresent(Bool.self, forKey: .isTeacher)
        self.isStudent = try container.decodeIfPresent(Bool.self, forKey: .isStudent)
        self.qrCode = try container.decodeIfPresent([String].self, forKey: .qrCode)
        self.isProfessors = try container.decodeIfPresent([String].self, forKey: .isProfessors)
        self.isStudents = try container.decodeIfPresent([String].self, forKey: .isStudents)
        self.scannedQr = try container.decodeIfPresent([String].self, forKey: .scannedQr)
        self.roster = try container.decodeIfPresent(Professor.self, forKey: .roster)
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isTeacher, forKey: .isTeacher)
        try container.encodeIfPresent(self.isStudent, forKey: .isStudent)
        try container.encodeIfPresent(self.qrCode, forKey: .qrCode)
        try container.encodeIfPresent(self.isStudents, forKey: .isStudents)
        try container.encodeIfPresent(self.isProfessors, forKey: .isProfessors)
        try container.encodeIfPresent(self.scannedQr, forKey: .scannedQr)
        try container.encodeIfPresent(self.roster, forKey: .roster)
    }
    
  
    
   
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    private let userCollection = Firestore.firestore().collection("users")
    private let rosterCollection = Firestore.firestore().collection("roster")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func rosterDocument(userId: String) -> DocumentReference {
        rosterCollection.document(userId)
    }
    
//    public func addStudentToRoster(student: Professor) throws -> DocumentReference {
//        let studentData = try Firestore.Encoder().encode(student)
//        return rosterCollection.addDocument(data: studentData)
//    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    
    
    func createNewUser(user: DBUser) async throws {
      try  userDocument(userId: user.userId).setData(from: user, merge: false)
   }
    
    func createNewRoster(user: Professor) async throws {
      try  userDocument(userId: user.students).setData(from: user, merge: false)
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
    
    func getRoster() async throws -> [Professor] {
            let querySnapshot = try await rosterCollection.getDocuments()
            return try querySnapshot.documents.compactMap { document in
                try document.data(as: Professor.self)
            }
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
    
    func updateUserQRCode(userId: String,qrCode: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.qrCode.rawValue : FieldValue.arrayUnion([qrCode]),
            ]
        try  await userDocument(userId: userId).updateData(data)
    }
   
    func addUserStudent(userId: String, student: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isStudents.rawValue : [student]
        ]
        try  await userDocument(userId: userId).updateData(data)
    }
    
    func addUserProfessor(userId:String, professor: String)async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isProfessors.rawValue : [professor]
        ]
        try  await userDocument(userId: userId).updateData(data)
    }
    
    
    func addScannedQr(userId:String, qrCode: String)async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.scannedQr.rawValue : FieldValue.arrayUnion([qrCode]),
        ]
        try  await userDocument(userId: userId).updateData(data)
    }
    
    func addStudentRoster(userId:String, student: Professor)async throws {
        guard let data = try? encoder.encode(student) else {
            throw URLError(.badURL)
        }
        let dict: [String:Any] = [
            DBUser.CodingKeys.roster.rawValue : data,
        ]
        try  await userDocument(userId: userId).updateData(dict)
    }
    
    func removeStudentRoster(userId:String)async throws {
        let data: [String:Any?] = [
            DBUser.CodingKeys.scannedQr.rawValue : nil
        ]
        try  await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
    
    
}
