import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

///What we wanna see in the user profile
struct DBUser: Codable {
    let userId: String
    let email: String?
    let userName: String?
    let dateCreated: Date?
    let isProfessors:[String]?
    let isStudents:[String]?
    let isTeacher: Bool?
    let isStudent: Bool?
    var qrCode: [String]?
    var scannedQr: [String]?
   
    
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.dateCreated = Date()
        self.isTeacher = false
        self.isStudent = false
        self.qrCode = [auth.uid]
        self.isProfessors = [auth.uid]
        self.isStudents = [auth.uid]
        self.scannedQr = [auth.uid]
        self.userName = auth.userName
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
        userName: String?
    ) {
        self.userId = userId
        self.email = email
        self.dateCreated = dateCreated
        self.isTeacher = isTeacher
        self.isStudent = isStudent
        self.qrCode = qrCode
        self.isProfessors = isProfessors
        self.isStudents = isStudents
        self.scannedQr = scannedQr
        self.userName = userName
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case dateCreated = "data_created"
        case isTeacher = "is_teacher"
        case isStudent = "is_student"
        case qrCode = "qrCode"
        case isProfessors = "Professors"
        case isStudents = "Students"
        case scannedQr = "ScannedQr"
        case userName = "UserName"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isTeacher = try container.decodeIfPresent(Bool.self, forKey: .isTeacher)
        self.isStudent = try container.decodeIfPresent(Bool.self, forKey: .isStudent)
        self.qrCode = try container.decodeIfPresent([String].self, forKey: .qrCode)
        self.isProfessors = try container.decodeIfPresent([String].self, forKey: .isProfessors)
        self.isStudents = try container.decodeIfPresent([String].self, forKey: .isStudents)
        self.scannedQr = try container.decodeIfPresent([String].self, forKey: .scannedQr)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isTeacher, forKey: .isTeacher)
        try container.encodeIfPresent(self.isStudent, forKey: .isStudent)
        try container.encodeIfPresent(self.qrCode, forKey: .qrCode)
        try container.encodeIfPresent(self.isStudents, forKey: .isStudents)
        try container.encodeIfPresent(self.isProfessors, forKey: .isProfessors)
        try container.encodeIfPresent(self.scannedQr, forKey: .scannedQr)
        try container.encodeIfPresent(self.userName, forKey: .userName)
    }
    
  
    
   
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    
    
    func createNewUser(user: DBUser) async throws {
      try  userDocument(userId: user.userId).setData(from: user, merge: false)
   }
    
    func getUser(userId: String) async throws -> DBUser {
         try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }

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
    

        func getRosterData() async throws -> [UserDocument] {
                let db = Firestore.firestore()
                let snapshot = try await db.collection("roster").getDocuments()
                var rosterData: [UserDocument] = []

                for document in snapshot.documents {
                    if let userDocument = try? document.data(as: UserDocument.self) {
                        rosterData.append(userDocument)
                    }
                }

                return rosterData
            }
    

}

