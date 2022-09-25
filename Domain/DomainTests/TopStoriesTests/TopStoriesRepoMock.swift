//
//  TopStoriesRepoMock.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain
import Combine

class TopStoriesRepoMock: TopStoriesRepoProtocol {
    
    var topStoriesSubject: PassthroughSubject<[TopStoryEntity], Never> = .init()
    var syncTopStoriesResult: Result<Void, Error> = .success(Void())
    var syncTopStoriesInput: TopStoriesInput? = nil
    var getTopStoriesInput: TopStoriesInput? = nil
    var topStoriesMock: [TopStoryEntity] = [
        TopStoryEntity(
            id: "1234",
            section: "section",
            subsection: "subsection",
            title: "title",
            abstract: "abstract",
            author: "author",
            publishDate: .at(Date()),
            segment: .science,
            multimedia: []
        )
    ]
    var deleteTopStoriesResult: Result<Void, Error> = .success(Void())

    var observeTopStories: AnyPublisher<[TopStoryEntity], Never> {
        self.topStoriesSubject.eraseToAnyPublisher()
    }
    
    func syncTopStories(segment: TopStoriesInput) async throws {
        self.syncTopStoriesInput = segment
        switch self.syncTopStoriesResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func getTopStories(segment: TopStoriesInput) -> [TopStoryEntity] {
        self.getTopStoriesInput = segment
        return self.topStoriesMock
    }
    
    func deleteTopStories() throws {
        switch self.deleteTopStoriesResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
}
