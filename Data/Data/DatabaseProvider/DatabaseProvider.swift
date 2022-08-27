//
//  DatabaseProvider.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Realm
import RealmSwift
import KeychainAccess

class DatabaseProvider: DatabaseProviderProtocol {
    
    private let realm: Realm
    private let keychain: Keychain
    private let defaults: UserDefaults = .standard
    
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()
    
    init(realm: Realm, keychain: Keychain) {
        self.realm = realm
        self.keychain = keychain
    }
    
    @MainActor
    func read<T: Object>() async -> [T] {
        self.realm.objects(T.self).map { $0 }
    }
    
    @MainActor
    func write<T: Object>(objects: [T]) async throws {
        try self.realm.write {
            self.realm.add(objects, update: .modified)
        }
    }
    
    @MainActor
    func deleteAll<T: Object>(of: T.Type) async throws {
        let objects: [T] = await self.read()
        try self.realm.write {
            self.realm.delete(objects)
        }
    }
    
    @MainActor
    func delete<T: Object>(of: T.Type, when: (T) -> Bool) async throws {
        let objects: [T] = await self.read().filter(when)
        try self.realm.write {
            self.realm.delete(objects)
        }
    }
    
    @MainActor
    func deleteAll() async throws {
        try self.realm.write {
            self.realm.deleteAll()
        }
    }
    
    func cache<T: Codable>(data: T, key: String) {
        if let json = try? self.encoder.encode(data) {
            self.defaults.set(json, forKey: key)
        } else {
            print("[USERDEFAULTS-ERROR]: Encoding Error")
        }
    }
    
    func cacheSafe<T: Codable>(data: T, key: String) {
        if let json = try? self.encoder.encode(data) {
            do {
                try self.keychain.accessibility(.whenUnlocked)
                    .set(json, key: key)
            } catch {
                print("[KEYCHAIN-ERROR]: \(error.localizedDescription)")
            }
        } else {
            print("[KEYCHAIN-ERROR]: Encoding Error")
        }
    }
    
    func getCache<T: Codable>(key: String) -> T? {
        if let json = self.defaults.data(forKey: key) {
            return try? self.decoder.decode(T.self, from: json)
        }
        return nil
    }
    
    func getSafeCache<T: Codable>(key: String) -> T? {
        if let json = try? self.keychain.getData(key) {
            return try? self.decoder.decode(T.self, from: json)
        }
        return nil
    }
    
}
