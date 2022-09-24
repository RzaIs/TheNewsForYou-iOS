//
//  AuthService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Foundation
import Domain

class AuthService: BaseService<AuthState, Void> {
    
    private let authLoginUseCase: BaseAsyncThrowsUseCase<AuthInput, Bool>
    private let authRegisterUseCase: BaseAsyncThrowsUseCase<AuthInput, Void>
    private let authLogoutUseCase: BaseThrowsUseCase<Void, Void>
    private let authGetUserEmailUseCase: BaseUseCase<Void, String>
    
    init(authLoginUseCase: BaseAsyncThrowsUseCase<AuthInput, Bool>,
         authRegisterUseCase: BaseAsyncThrowsUseCase<AuthInput, Void>,
         authLogoutUseCase: BaseThrowsUseCase<Void, Void>,
         authGetUserEmailUseCase: BaseUseCase<Void, String>
    ) {
        self.authLoginUseCase = authLoginUseCase
        self.authRegisterUseCase = authRegisterUseCase
        self.authLogoutUseCase = authLogoutUseCase
        self.authGetUserEmailUseCase = authGetUserEmailUseCase
    }
    
    func login(_ email: String, _ password: String) async {
        do {
            let isVerified = try await self.authLoginUseCase.execute(
                input: AuthInput(email: email, password: password)
            )
            self.post(state: .login(verified: isVerified))
        } catch {
            self.show(error: error)
        }
        
    }
    
    func register(_ email: String, _ password: String) async {
        do {
            try await self.authRegisterUseCase.execute(
                input: AuthInput(email: email, password: password)
            )
            self.post(state: .register)
        } catch {
            self.show(error: error)
        }
    }
    
    func logout() {
        do {
            try self.authLogoutUseCase.execute(input: Void())
            self.post(state: .logout)
        } catch {
            self.show(error: error)
        }
    }
    
    var userEmail: String {
        self.authGetUserEmailUseCase.execute(input: Void())
    }
}

enum AuthState {
    case login(verified: Bool)
    case register
    case logout
}
