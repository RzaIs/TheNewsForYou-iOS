//
//  FirebaseProvider.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseProvider: FirebaseProviderProtocol {
    
    private let fireBaseAuth = FirebaseAuth.Auth.auth()
    private let firestore = FirebaseFirestore.Firestore.firestore()
    
    func isSignedIn() -> Bool {
        self.fireBaseAuth.currentUser != nil
    }
    
    func createUser(email: String, password: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.fireBaseAuth.createUser(withEmail: email, password: password) { result, error in
                if let _ = result {
                    continuation.resume(returning: Void())
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Auth-CreateUser", code: 1))
                }
            }
        }
    }
    
    func signin(email: String, password: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.fireBaseAuth.signIn(withEmail: email, password: password) { result, error in
                if let _ = result {
                    continuation.resume(returning: Void())
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Auth-Signin", code: 2))
                }
            }
        }
    }
    
    func signout() throws {
        try self.fireBaseAuth.signOut()
    }
    
    func getDocuments<T: FirestoreObject>() async throws -> [T] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let _ = self.fireBaseAuth.currentUser else {
                continuation.resume(throwing: NSError(domain: "User not defined", code: 1))
                return
            }
            self.firestore.collection(T.collection).getDocuments { snapshot, error in
                if let documents = snapshot?.documents.map({ T(document: $0) }) {
                    continuation.resume(returning: documents)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Firebase-Firestore", code: 3))
                }
            }
        }
    }
    
    func deleteDocument<T: FirestoreObject>(_ type: T.Type, id: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            guard let _ = self.fireBaseAuth.currentUser else {
                continuation.resume(throwing: NSError(domain: "User not defined", code: 1))
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
            guard let user = self.fireBaseAuth.currentUser else {
                continuation.resume(throwing: NSError(domain: "User not defined", code: 1))
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
}
