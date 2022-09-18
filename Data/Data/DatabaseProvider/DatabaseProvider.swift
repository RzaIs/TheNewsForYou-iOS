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
    
    func read<T: Object>() -> [T] {
        self.main {
            self.realm.objects(T.self).freeze().map { $0 }
        }
    }
    
    func write<T: Object>(objects: [T]) throws {
        try self.main {
            try self.realm.write {
                self.realm.add(objects, update: .modified)
            }
        }
    }
    
    func deleteAll<T: Object>(of: T.Type) throws {
        try self.main {
            let objects = self.realm.objects(T.self)
            try self.realm.write {
                self.realm.delete(objects)
            }
        }
    }

    func delete<T: Object>(of: T.Type, when: @escaping (T) -> Bool) throws {
        try self.main {
            let objects = self.realm.objects(T.self).filter(when)
            try self.realm.write {
                self.realm.delete(objects)
            }
        }
    }
    
    func deleteAll() throws {
        try self.main {
            try self.realm.write {
                self.realm.deleteAll()
            }
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
    
    func main<T>(task: @escaping () throws -> T ) throws -> T {
        if !Thread.isMainThread {
            return try DispatchQueue.main.sync {
                return try task()
            }
        } else {
            return try task()
        }
    }
    
    func main<T>(task: @escaping () -> T ) -> T {
        if !Thread.isMainThread {
            return DispatchQueue.main.sync {
                return task()
            }
        } else {
            return task()
        }
    }
}
