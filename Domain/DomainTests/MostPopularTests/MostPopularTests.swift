//
//  MostPopularTests.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import XCTest
import Combine
@testable import Domain

class MostPopularTests: XCTestCase {
    
    var cancelBag: Set<AnyCancellable> = .init()
    var repo: MostPopularRepoMock!

    override func setUp() {
        self.repo = .init()
    }
    
    func testObserveMostPopular() {
        let exp = XCTestExpectation()
        let useCase = ObserveMostPopularUseCase(repo: self.repo)
        
        useCase.observe(input: Void()).sink { mostPopular in
            XCTAssertEqual(mostPopular, self.repo.mostPopularMock)
            exp.fulfill()
        }.store(in: &self.cancelBag)

        self.repo.mostPopularSubject.send(self.repo.mostPopularMock)
        wait(for: [exp], timeout: 1.0)
    }

    func testSyncMostPopularSuccess() {
        let exp = XCTestExpectation()
        let useCase = SyncMostPopularUseCase(repo: self.repo)
        self.repo.syncMostPopularResult = .success(Void())
        Task {
            do {
                try await useCase.execute(input: Void())
                exp.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testSyncMostPopularFail() {
        let exp = XCTestExpectation()
        let useCase = SyncMostPopularUseCase(repo: self.repo)
        self.repo.syncMostPopularResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await useCase.execute(input: Void())
            } catch {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }

    override func tearDown() {
        self.cancelBag.forEach { $0.cancel() }
        self.cancelBag.removeAll()
    }
}

extension MostPopularEntity: Equatable {
    public static func == (lhs: MostPopularEntity, rhs: MostPopularEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.section == rhs.section &&
        lhs.subsection == rhs.subsection &&
        lhs.title == rhs.title &&
        lhs.abstract == rhs.abstract &&
        lhs.author == rhs.author &&
        lhs.publishDate == rhs.publishDate &&
        lhs.media == rhs.media
    }
}
