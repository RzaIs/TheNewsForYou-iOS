//
//  MostPopularLocalDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 11.09.22.
//

import Combine

class MostPopularLocalDataSource: MostPopularLocalDataSourceProtocol {
    
    let mostPopularSubject: CurrentValueSubject<[MostPopularLocalDTO], Never>
    let databaseProvider: DatabaseProviderProtocol
    
    init(databaseProvider: DatabaseProviderProtocol) {
        self.databaseProvider = databaseProvider
        self.mostPopularSubject = .init(databaseProvider.read())
    }
    
    func removeAll() throws {
        try self.databaseProvider.deleteAll(of: MostPopularLocalDTO.self)
    }
    
    func save(mostPopular: [MostPopularLocalDTO]) throws {
        try self.databaseProvider.deleteAll(of: MostPopularLocalDTO.self)
        try self.databaseProvider.write(objects: mostPopular)
        self.mostPopularSubject.send(mostPopular)
    }
    
    func observeMostPopular() -> AnyPublisher<[MostPopularLocalDTO], Never> {
        self.mostPopularSubject.eraseToAnyPublisher()
    }
}
