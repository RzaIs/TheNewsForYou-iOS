//
//  FirebaseProviderProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import FirebaseAuth

protocol FirebaseProviderProtocol {
    func isSignedIn() -> Bool
    func createUser(email: String, password: String) async throws
    func signin(email: String, password: String) async throws
    func signout() throws
    func getDocuments<T: FirestoreObject>(field: String, value: Any) async throws -> [T]
    func deleteDocument<T: FirestoreObject>(_ type: T.Type, id: String) async throws
    func sendDocument<T: DictionaryObject>(document: T) async throws
    func syncRemoteConfig() async throws
    func getApiKey() -> String?
}
