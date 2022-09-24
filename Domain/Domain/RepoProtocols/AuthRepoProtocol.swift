//
//  AuthRepoProtocol.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Foundation

public protocol AuthRepoProtocol {
    func login(credentials: AuthInput) async throws -> Bool
    func register(credentials: AuthInput) async throws
    func logout() throws
    func setFirstOpening(date: Date)
    var getFirstOpeningDate: FirstOpeningEntity { get }
    var isLeoggedIn: Bool { get }
    var userEmail: String { get }
}
