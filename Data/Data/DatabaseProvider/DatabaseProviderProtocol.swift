//
//  DatabaseProviderProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Realm
import RealmSwift

protocol DatabaseProviderProtocol {
    func read<T: Object>() -> [T]
    func write<T: Object>(objects: [T]) throws
    func deleteAll<T: Object>(of: T.Type) throws
    func delete<T: Object>(of: T.Type, when: @escaping (T) -> Bool) throws
    func deleteAll() throws
    
    func cache<T: Codable>(data: T, key: String)
    func cacheSafe<T: Codable>(data: T, key: String)
    func getCache<T: Codable>(key: String) -> T?
    func getSafeCache<T: Codable>(key: String) -> T?
}
