//
//  DatabaseProviderProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Realm
import RealmSwift

protocol DatabaseProviderProtocol {
    func read<T: Object>() async -> [T]
    func write<T: Object>(objects: [T]) async throws
    func deleteAll<T: Object>(of: T.Type) async throws
    func delete<T: Object>(of: T.Type, when: (T) -> Bool) async throws
    func deleteAll() async throws
    
    func cache<T: Codable>(data: T, key: String)
    func cacheSafe<T: Codable>(data: T, key: String)
    func getCache<T: Codable>(key: String) -> T?
    func getSafeCache<T: Codable>(key: String) -> T?
}
