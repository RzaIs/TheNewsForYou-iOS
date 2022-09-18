//
//  TopStoriesLocalDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 01.09.22.
//

import Combine

class TopStoriesLocalDataSource: TopStoriesLocalDataSourceProtocol {
    
    let topStoriesSubject: CurrentValueSubject<[TopStoryLocalDTO], Never>
    let databaseProvider: DatabaseProviderProtocol
    
    init(databaseProvider: DatabaseProviderProtocol) {
        self.databaseProvider = databaseProvider
        self.topStoriesSubject = .init(databaseProvider.read())
    }
    
    func removeAll() throws {
        try self.databaseProvider.deleteAll(of: TopStoryLocalDTO.self)
    }
    
    func removeAll(when: @escaping (TopStoryLocalDTO) -> Bool) throws {
        try self.databaseProvider.delete(of: TopStoryLocalDTO.self, when: when)
    }
    
    func save(segment: String, topStories: [TopStoryLocalDTO]) throws {
        try self.databaseProvider.delete(of: TopStoryLocalDTO.self, when: {
            $0.segment == segment
        })
        try self.databaseProvider.write(objects: topStories)
        self.topStoriesSubject.send(topStories)
    }
    
    func getTopStories() -> [TopStoryLocalDTO] {
        self.databaseProvider.read()
    }
    
    func getTopStories(when: (TopStoryLocalDTO) -> Bool) -> [TopStoryLocalDTO] {
        self.databaseProvider.read().filter(when)
    }
    
    func observeTopStories() -> AnyPublisher<[TopStoryLocalDTO], Never> {
        self.topStoriesSubject.eraseToAnyPublisher()
    }
}
