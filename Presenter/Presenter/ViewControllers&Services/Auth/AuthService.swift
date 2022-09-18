//
//  AuthService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Foundation
import Domain

class AuthService: BaseService<AuthState, Void> {
    
    private let authLoginUseCase: BaseAsyncThrowsUseCase<AuthInput, Void>
    private let authRegisterUseCase: BaseAsyncThrowsUseCase<AuthInput, Void>
    
    init(authLoginUseCase: BaseAsyncThrowsUseCase<AuthInput, Void>,
         authRegisterUseCase: BaseAsyncThrowsUseCase<AuthInput, Void>
    ) {
        self.authLoginUseCase = authLoginUseCase
        self.authRegisterUseCase = authRegisterUseCase
    }
    
    func login(_ email: String, _ password: String) async {
        do {
            try await self.authLoginUseCase.execute(
                input: AuthInput(email: email, password: password)
            )
            self.post(state: .success)
        } catch {
            self.show(error: error)
        }
        
    }
    
    func register(_ email: String, _ password: String) async {
        do {
            try await self.authRegisterUseCase.execute(
                input: AuthInput(email: email, password: password)
            )
            self.post(state: .success)
        } catch {
            self.show(error: error)
        }
    }
}

enum AuthState {
    case success
}
