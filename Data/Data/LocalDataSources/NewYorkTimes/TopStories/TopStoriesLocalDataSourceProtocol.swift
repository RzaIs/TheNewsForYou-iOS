//
//  TopStoriesLocalDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 31.08.22.
//

import Combine

protocol TopStoriesLocalDataSourceProtocol {
    func removeAll() throws
    func removeAll(when: @escaping (TopStoryLocalDTO) -> Bool) throws
    func save(segment: String, topStories: [TopStoryLocalDTO]) throws
    func getTopStories() -> [TopStoryLocalDTO]
    func getTopStories(when: (TopStoryLocalDTO) -> Bool) -> [TopStoryLocalDTO]
    func observeTopStories() -> AnyPublisher<[TopStoryLocalDTO], Never>
}
