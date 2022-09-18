//
//  TopStoriesRepoProtocol.swift
//  Domain
//
//  Created by Rza Ismayilov on 01.09.22.
//

import Combine

public protocol TopStoriesRepoProtocol {
    var observeTopStories: AnyPublisher<[TopStoryEntity], Never> { get }
    func syncTopStories(segment: TopStoriesInput) async throws
    func getTopStories(segment: TopStoriesInput) -> [TopStoryEntity]
    func deleteTopStories() throws
}
