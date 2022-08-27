//
//  FirebaseProviderProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

protocol FirebaseProviderProtocol {
    func isSignedIn() -> Bool
    func createUser(email: String, password: String) async throws
    func signin(email: String, password: String) async throws
    func signout() throws
}
