//
//  AuthRepoProtocol.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Foundation

public protocol AuthRepoProtocol {
    func isLeoggedIn() -> Bool
    func login(credentials: AuthInput) async throws
    func register(credentials: AuthInput) async throws
    func logout() throws
}
