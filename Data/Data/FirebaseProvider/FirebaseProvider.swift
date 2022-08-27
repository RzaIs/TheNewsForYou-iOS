//
//  FirebaseProvider.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Firebase
import FirebaseAuth

class FirebaseProvider: FirebaseProviderProtocol {
    
    private let fireBaseAuth = FirebaseAuth.Auth.auth()
    
    func isSignedIn() -> Bool {
        self.fireBaseAuth.currentUser != nil
    }
    
    func createUser(email: String, password: String) async throws {
        return try await withUnsafeThrowingContinuation { continuation in
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
        return try await withUnsafeThrowingContinuation { continuation in
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
    
}
