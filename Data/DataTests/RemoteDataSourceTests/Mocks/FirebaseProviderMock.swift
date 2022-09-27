//
//  FirebaseProviderMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 26.09.22.
//

@testable import Data

class FirebaseProviderMock: FirebaseProviderProtocol {
    
    var isSignedInMock: Bool = true
    
    var createUserInput: (String, String)? = nil
    var createUserResult: Result<Void, Error> = .success(Void())
    
    var verifyEmailResult: Result<Void, Error> = .success(Void())
    
    var signinInput: (String, String)? = nil
    var signinResult: Result<Bool, Error> = .success(false)
    
    var signoutResult: Result<Void, Error> = .success(Void())
    
    var getDocumentsInput: (String, Any)? = nil
    var getDocumentsResult: Result<[FirestoreObject], Error> = .success([])
    
    var deleteDocumentInput: (FirestoreObject.Type, String)? = nil
    var deleteDocumentResult: Result<Void, Error> = .success(Void())
    
    var sendDocumentInput: DictionaryObject? = nil
    var sendDocumentResult: Result<Void, Error> = .success(Void())
    
    var syncRemoteConfigResult: Result<Void, Error> = .success(Void())
    
    var getApiKeyMock: String? = "asdfghjkl"
    
    var getEmailMock: String? = "email@email.com"
    
    var commentsMock = [CommentRemoteDTO(id: "12345", document: [:], isAdmin: true)]
    var likseMock = [LikeRemoteDTO(id: "1234", document: [:], isAdmin: false)]
    
    func isSignedIn() -> Bool {
        self.isSignedInMock
    }
    
    func createUser(email: String, password: String) async throws {
        self.createUserInput = (email, password)
        switch self.createUserResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func verifyEmail() async throws {
        switch self.verifyEmailResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func signin(email: String, password: String) async throws -> Bool {
        self.signinInput = (email, password)
        switch self.signinResult {
        case .success(let verified):
            return verified
        case .failure(let error):
            throw error
        }
    }
    
    func signout() throws {
        switch self.signoutResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func getDocuments<T: FirestoreObject>(field: String, value: Any) async throws -> [T] {
        self.getDocumentsInput = (field, value)
        switch self.getDocumentsResult {
        case .success(let data):
            return data as? [T] ?? []
        case .failure(let error):
            throw error
        }
    }
    
    func deleteDocument<T: FirestoreObject>(_ type: T.Type, id: String) async throws {
        self.deleteDocumentInput = (T.self, id)
        switch self.deleteDocumentResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func sendDocument<T: DictionaryObject>(document: T) async throws {
        self.sendDocumentInput = document
        switch self.sendDocumentResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func syncRemoteConfig() async throws {
        switch self.syncRemoteConfigResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func getApiKey() -> String? {
        self.getApiKeyMock
    }
    
    func getEmail() -> String? {
        self.getEmailMock
    }
}
