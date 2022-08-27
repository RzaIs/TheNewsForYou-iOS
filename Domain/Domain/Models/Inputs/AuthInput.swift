//
//  AuthInput.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

public class AuthInput {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
