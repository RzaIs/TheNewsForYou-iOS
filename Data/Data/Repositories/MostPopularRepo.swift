//
//  MostPopularRepo.swift
//  Data
//
//  Created by Rza Ismayilov on 11.09.22.
//

import Domain
import Combine

class MostPopularRepo: MostPopularRepoProtocol {
    
    private let localDataSource: MostPopularLocalDataSourceProtocol
    private let remoteDataSource: MostPopularRemoteDataSourceProtocol
    
    init(localDataSource: MostPopularLocalDataSourceProtocol,
         remoteDataSource: MostPopularRemoteDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func syncMostPopular() async throws {
        var step = 0
        do {
            let mostPopular = try await self.remoteDataSource
                .getMostPopular
                .results
                .filter { $0.url.contains("https://") }
                .map { $0.toLocal }
            step = 1
            try self.localDataSource.save(mostPopular: mostPopular)
        } catch {
            throw UIError(title: "Sync Most Popular Error", message: "\(error.localizedDescription)\nKey: @0.\(step)")
        }
    }
    
    func deleteMostPopular() throws {
        do {
            try self.localDataSource.removeAll()
        } catch {
            throw UIError(title: "Delete Most Popular Error", message: "\(error.localizedDescription)\nKey: @1")
        }
    }
    
    var observeMostPopular: AnyPublisher<[MostPopularEntity], Never> {
        self.localDataSource.observeMostPopular()
            .receive(on: DispatchQueue.main)
            .map { localDTOs in
                localDTOs.map { $0.toDomain }
                    .sorted { $0.publishDate > $1.publishDate }
            }.eraseToAnyPublisher()
    }
}
