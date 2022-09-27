//
//  AuthLocalDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 26.09.22.
//

@testable import Data

class AuthLocalDataSourceMock: AuthLocalDataSourceProtocol {
    
    var getFirstOpenDateMock: Date = Date()
    var setFirstOpenDateInput: Date? = nil
    
    var getFirstOpenDate: Date? {
        self.getFirstOpenDateMock
    }
    
    func setFirstOpenDate(_ date: Date) {
        self.setFirstOpenDateInput = date
    }
}
