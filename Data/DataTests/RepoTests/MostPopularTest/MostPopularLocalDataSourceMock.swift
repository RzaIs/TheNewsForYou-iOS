//
//  MostPopularLocalDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

@testable import Data
import Combine

class MostPopularLocalDataSourceMock: MostPopularLocalDataSourceProtocol {
    
    var removeAllResult: MostPopularLocalResult<Void> = .success(Void())
    
    var saveResult: MostPopularLocalResult<Void> = .success(Void())
    var saveInput: [MostPopularLocalDTO]? = nil
    
    var mostPopularPublisher: PassthroughSubject<[MostPopularLocalDTO], Never> = .init()
    var mostPopularMock: [MostPopularLocalDTO] = [
        MostPopularLocalDTO(
            id: 123124,
            section: "world",
            subsection: "art",
            title: "title",
            abstract: "abstract",
            url: "https://google.com",
            author: "author",
            publishDate: "20.08.2002",
            media: []
        )
    ]
    
    func removeAll() throws {
        switch self.removeAllResult {
        case .success(_):
            return
        case .fail(let error):
            throw error
        }
    }
    
    func save(mostPopular: [MostPopularLocalDTO]) throws {
        self.saveInput = mostPopular
        switch self.saveResult {
        case .success(_):
            return
        case .fail(let error):
            throw error
        }
    }
    
    func observeMostPopular() -> AnyPublisher<[MostPopularLocalDTO], Never> {
        self.mostPopularPublisher.eraseToAnyPublisher()
    }
}

enum MostPopularLocalResult<T> {
    case success(T)
    case fail(Error)
}
