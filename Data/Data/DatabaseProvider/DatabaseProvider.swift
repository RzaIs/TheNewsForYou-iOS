//
//  DatabaseProvider.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Realm
import RealmSwift

class DatabaseProvider: DatabaseProviderProtocol {
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
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
}
