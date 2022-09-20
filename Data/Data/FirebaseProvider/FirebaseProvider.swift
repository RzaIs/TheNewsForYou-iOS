//
//  FirebaseProvider.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseRemoteConfig

class FirebaseProvider: FirebaseProviderProtocol {
    
    private let apiKeyConfigKey: String = "nyt_api_key"
    
    private let auth: Auth = .auth()
    private let firestore: Firestore = .firestore()
    private let remoteConfig: RemoteConfig = .remoteConfig()
    
    func isSignedIn() -> Bool {
        self.auth.currentUser != nil
    }
    
    init() {
        let remoteConfigSettings = RemoteConfigSettings()
        remoteConfigSettings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = remoteConfigSettings
    }
    
    func createUser(email: String, password: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.auth.createUser(withEmail: email, password: password) { result, error in
                if let _ = result {
                    continuation.resume(returning: Void())
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: FirebaseErrors.createUser.rawValue, code: 1))
                }
            }
        }
    }
    
    func signin(email: String, password: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.auth.signIn(withEmail: email, password: password) { result, error in
                if let _ = result {
                    continuation.resume(returning: Void())
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: FirebaseErrors.singIn.rawValue, code: 2))
                }
            }
        }
    }
    
    func signout() throws {
        try self.auth.signOut()
    }
    
    func getDocuments<T: FirestoreObject>() async throws -> [T] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let user = self.auth.currentUser else {
                continuation.resume(throwing: NSError(domain: FirebaseErrors.userNotDefined.rawValue, code: 1))
                return
            }
            self.firestore.collection(T.collection).getDocuments { snapshot, error in
                if let documents = snapshot?.documents.map({ documentSnapshot in
                    if let authorID = documentSnapshot["authorID"] as? String, authorID == user.uid {
                        return T(document: documentSnapshot, isAdmin: true)
                    } else {
                        return T(document: documentSnapshot, isAdmin: false)
                    }
                }) {
                    continuation.resume(returning: documents)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: FirebaseErrors.firestore.rawValue, code: 3))
                }
            }
        }
    }
    
    func deleteDocument<T: FirestoreObject>(_ type: T.Type, id: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            guard let _ = self.auth.currentUser else {
                continuation.resume(throwing: NSError(domain: FirebaseErrors.userNotDefined.rawValue, code: 1))
                return
            }
            self.firestore.collection(T.collection).document(id).delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: Void())
                }
            }
        }
    }
    
    func sendDocument<T: DictionaryObject>(document: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            guard let user = self.auth.currentUser else {
                continuation.resume(throwing: NSError(domain: FirebaseErrors.userNotDefined.rawValue, code: 1))
                return
            }
            var dictionary = document.toDictionary
            dictionary["authorID"] = user.uid
            dictionary["authorEmail"] = user.email
            
            self.firestore.collection(T.collection).addDocument(data: dictionary) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: Void())
                }
            }
        }
    }
    
    func syncRemoteConfig() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.remoteConfig.fetchAndActivate { status, error in
                if status == .successFetchedFromRemote || status == .successUsingPreFetchedData  {
                    continuation.resume()
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: FirebaseErrors.remoteConfig.rawValue, code: 1))
                }
            }
        }
    }
    
    func getApiKey() -> String? {
        self.remoteConfig.configValue(forKey: self.apiKeyConfigKey).stringValue
    }
}

enum FirebaseErrors: String {
    case userNotDefined = "User not defined"
    case createUser = "Error at registration"
    case singIn = "Error at login"
    case firestore = "Error at firestore"
    case remoteConfig = "Error at remote config"
}
