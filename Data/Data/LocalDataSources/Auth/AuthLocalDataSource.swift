//
//  AuthLocalDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 29.08.22.
//

class AuthLocalDataSource: AuthLocalDataSourceProtocol {

    private let databaseProvider: DatabaseProviderProtocol
    
    init(databaseProvider: DatabaseProviderProtocol) {
        self.databaseProvider = databaseProvider
    }
    
    var getFirstOpenDate: Date? {
        self.databaseProvider.getCache(key: DataKeys.first_open_date.rawValue)
    }
    
    func setFirstOpenDate(_ date: Date) {
        self.databaseProvider.cache(data: date, key: DataKeys.first_open_date.rawValue)
    }
}
