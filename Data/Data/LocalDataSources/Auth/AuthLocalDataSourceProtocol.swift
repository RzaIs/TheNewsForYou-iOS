//
//  AuthLocalDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 29.08.22.
//

protocol AuthLocalDataSourceProtocol {
    var getFirstOpenDate: Date? { get }
    func setFirstOpenDate(_ date: Date)
}
