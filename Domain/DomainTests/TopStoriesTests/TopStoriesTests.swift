//
//  TopStoriesTests.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import XCTest
import Combine
@testable import Domain

class TopStoriesTests: XCTestCase {
    
    var cancelBag: Set<AnyCancellable> = .init()
    var repo: TopStoriesRepoMock!

    override func setUp() {
        self.repo = .init()
    }
    
    func testObserveTopStories() {
        let exp = XCTestExpectation()
        let useCase = ObserveTopStoriesUseCase(repo: self.repo)
        
        useCase.observe(input: Void()).sink { topStories in
            XCTAssertEqual(topStories, self.repo.topStoriesMock)
            exp.fulfill()
        }.store(in: &self.cancelBag)
        
        self.repo.topStoriesSubject.send(self.repo.topStoriesMock)
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSyncTopStoriesSuccess() {
        let exp = XCTestExpectation()
        let useCase = SyncTopStoriesUseCase(repo: self.repo)
        self.repo.syncTopStoriesResult = .success(Void())
        Task {
            do {
                try await useCase.execute(input: .science)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.syncTopStoriesInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testSyncTopStoriesFail() {
        let exp = XCTestExpectation()
        let useCase = SyncTopStoriesUseCase(repo: self.repo)
        self.repo.syncTopStoriesResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await useCase.execute(input: .science)
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.syncTopStoriesInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testGetTopStories() {
        let useCase = GetTopStoriesUseCase(repo: self.repo)
        let topStories = useCase.execute(input: .science)
        XCTAssertEqual(self.repo.topStoriesMock, topStories)
        XCTAssertNotNil(self.repo.getTopStoriesInput)
    }
    
    override func tearDown() {
        self.cancelBag.forEach { $0.cancel() }
        self.cancelBag.removeAll()
    }
}

extension TopStoryEntity: Equatable {
    public static func == (lhs: TopStoryEntity, rhs: TopStoryEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.section == rhs.section &&
        lhs.subsection == rhs.subsection &&
        lhs.title == rhs.title &&
        lhs.abstract == rhs.abstract &&
        lhs.author == rhs.author &&
        lhs.publishDate == rhs.publishDate &&
        lhs.segment == rhs.segment &&
        lhs.multimedia == rhs.multimedia
    }
}
