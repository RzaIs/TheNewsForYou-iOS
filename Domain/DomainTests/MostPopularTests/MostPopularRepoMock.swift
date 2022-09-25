//
//  MostPopularRepoMock.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain
import Combine

class MostPopularRepoMock: MostPopularRepoProtocol {
    
    var syncMostPopularResult: Result<Void, Error> = .success(Void())
    var deleteMostPopularResult: Result<Void, Error> = .success(Void())
    var mostPopularSubject: PassthroughSubject<[MostPopularEntity], Never> = .init()
    var mostPopularMock: [MostPopularEntity] = [
        MostPopularEntity(
            id: 1234,
            section: "section",
            subsection: "subsection",
            title: "title",
            abstract: "abstract",
            author: "author",
            publishDate: .at(Date()),
            media: []
        )
    ]

    func syncMostPopular() async throws {
        switch self.syncMostPopularResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func deleteMostPopular() throws {
        switch self.deleteMostPopularResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    var observeMostPopular: AnyPublisher<[MostPopularEntity], Never> {
        self.mostPopularSubject.eraseToAnyPublisher()
    }
}
