//
//  TopStoriesRepo.swift
//  Data
//
//  Created by Rza Ismayilov on 01.09.22.
//

import Combine
import Domain

class TopStoriesRepo: TopStoriesRepoProtocol {
    
    let localDataSource: TopStoriesLocalDataSourceProtocol
    let remoteDataSource: TopStoriesRemoteDataSourceProtocol
    
    init(localDataSource: TopStoriesLocalDataSourceProtocol,
         remoteDataSource: TopStoriesRemoteDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func syncTopStories(segment: TopStoriesInput) async throws {
        var step = 0
        do {
            let topStories = try await self.remoteDataSource
                .getTopStories(segment: segment.rawValue)
                .results
                .filter { remoteDTO in
                    remoteDTO.url.contains("https://")
                }.map { remoteDTO in
                    remoteDTO.toLocal(segment: segment.rawValue)
                }
            step = 1
            try self.localDataSource.save(segment: segment.rawValue, topStories: topStories)
        } catch {
            throw UIError(title: "Sync Top Stories Error", message: "\(error.localizedDescription)\nKey: @0.\(step)")
        }
    }
    
    var observeTopStories: AnyPublisher<[TopStoryEntity], Never> {
        self.localDataSource.observeTopStories()
            .receive(on: DispatchQueue.main)
            .map { localDTOs in
                localDTOs.map { $0.toDomain }
                    .sorted { $0.publishDate > $1.publishDate }
            }.eraseToAnyPublisher()
    }
    
    func getTopStories(segment: TopStoriesInput) -> [TopStoryEntity] {
        self.localDataSource.getTopStories { $0.segment == segment.rawValue }
            .map { $0.toDomain }
            .sorted { $0.publishDate > $1.publishDate }
    }
    
    func deleteTopStories() throws {
        do {
            try self.localDataSource.removeAll()
        } catch {
            throw UIError(title: "Delete Top Stories Error", message: "\(error.localizedDescription)\nKey: @1")
        }
    }
}
