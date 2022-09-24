//
//  TopStoriesLocalDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 22.09.22.
//

import Combine
import Domain
@testable import Data

class TopStoriesLocalDataSourceMock: TopStoriesLocalDataSourceProtocol {
    
    var removeAllResult: TopStoriesLocalResult<Void> = .success(Void())
    
    var removeAllWhenResult: TopStoriesLocalResult<Void> = .success(Void())
    var removeAllInput: ((TopStoryLocalDTO) -> Bool)? = nil
    
    var saveResult: TopStoriesLocalResult<Void> = .success(Void())
    var saveInput: (String, [TopStoryLocalDTO])? = nil
    
    var getStoriesInput: ((TopStoryLocalDTO) -> Bool)? = nil
    
    var topStoriesMock: [TopStoryLocalDTO] = [
        TopStoryLocalDTO(
            id: "1234",
            section: "science",
            subsection: "world",
            title: "title",
            abstract: "description",
            url: "https://youtube.com",
            author: "Rza Is",
            publishDate: "20.08.2002",
            segment: "home",
            multimedia: [
                "https://en.wikipedia.org/wiki/Boracay#/media/File:Paraw_sailboats_in_Boracay_2.jpg"
            ])
    ]
    
    var topStoriesPublisher: PassthroughSubject<[TopStoryLocalDTO], Never> = .init()
    
    func removeAll() throws {
        switch self.removeAllResult {
        case .success(_):
            return
        case .fail(let error):
            throw error
        }
    }
    
    func removeAll(when: @escaping (TopStoryLocalDTO) -> Bool) throws {
        self.removeAllInput = when
        switch self.removeAllWhenResult {
        case .success(_):
            return
        case .fail(let error):
            throw error
        }
    }
    
    func save(segment: String, topStories: [TopStoryLocalDTO]) throws {
        self.saveInput = (segment, topStories)
        switch self.saveResult {
        case .success(_):
            return
        case .fail(let error):
            throw error
        }
    }
    
    func getTopStories() -> [TopStoryLocalDTO] {
        self.topStoriesMock
    }
    
    func getTopStories(when: @escaping (TopStoryLocalDTO) -> Bool) -> [TopStoryLocalDTO] {
        self.getStoriesInput = when
        return self.topStoriesMock
    }
    
    func observeTopStories() -> AnyPublisher<[TopStoryLocalDTO], Never> {
        self.topStoriesPublisher.eraseToAnyPublisher()
    }
}

enum TopStoriesLocalResult<T> {
    case success(T)
    case fail(Error)
}
