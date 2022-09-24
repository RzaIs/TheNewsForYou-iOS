//
//  AuthRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Domain

public protocol AuthRemoteDataSourceProtocol {
    func loggedIn() -> Bool
    func register(credentials: AuthInput) async throws
    func verify() async throws
    func login(credentials: AuthInput) async throws -> Bool
    func logout() throws
    func getEmail() -> String
}
