//
//  TopStoriesTest.swift
//  DataTests
//
//  Created by Rza Ismayilov on 21.09.22.
//

import Domain
import XCTest
import Combine
@testable import Data

class TopStoriesTest: XCTestCase {
    
    var cancelBag: Set<AnyCancellable> = .init()
    
    var remoteDataSourceMock: TopStoriesRemoteDataSourceMock!
    var localDataSourceMock: TopStoriesLocalDataSourceMock!
    var repo: TopStoriesRepo!

    override func setUp() {
        self.remoteDataSourceMock = .init()
        self.localDataSourceMock = .init()
        self.repo = TopStoriesRepo(
            localDataSource: self.localDataSourceMock,
            remoteDataSource: self.remoteDataSourceMock
        )
    }
    
    func testGetTopStories() {
        let result = self.repo.getTopStories(segment: .science)
        XCTAssertEqual(result, self.localDataSourceMock.topStoriesMock.map { $0.toDomain })
        XCTAssertNotNil(self.localDataSourceMock.getStoriesInput)
    }
    
    func testSyncTopStoriesSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.getTopStoriesResult = .success(BaseRemoteDTO(results: []))
        self.localDataSourceMock.saveResult = .success(Void())
        Task {
            do {
                try await self.repo.syncTopStories(segment: self.remoteDataSourceMock.mockSegment1)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.segmentInput)
            XCTAssertNotNil(self.localDataSourceMock.saveInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testSyncTopStoriesRemoteFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.getTopStoriesResult = .fail(NSError(domain: "test", code: 0))
        Task {
            do {
                try await self.repo.syncTopStories(segment: self.remoteDataSourceMock.mockSegment2)
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.segmentInput)
            XCTAssertNil(self.localDataSourceMock.saveInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSyncTopStoriesLocalFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.getTopStoriesResult = .success(.init(results: []))
        self.localDataSourceMock.saveResult = .fail(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.repo.syncTopStories(segment: self.remoteDataSourceMock.mockSegment3)
                try await self.repo.syncTopStories(segment: self.remoteDataSourceMock.mockSegment4)
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.segmentInput)
            XCTAssertNotNil(self.localDataSourceMock.saveInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testObserveTopStories() {
        let exp = XCTestExpectation()
        self.repo.observeTopStories.sink { topStories in
            XCTAssertEqual(topStories, self.localDataSourceMock.topStoriesMock.map { $0.toDomain })
            exp.fulfill()
        }.store(in: &self.cancelBag)
        
        self.localDataSourceMock.topStoriesPublisher.send(self.localDataSourceMock.topStoriesMock)
        wait(for: [exp], timeout: 1.0)
    }
    
    func testDeleteTopStoriesSuccess() {
        let exp = XCTestExpectation()
        self.localDataSourceMock.removeAllResult = .success(Void())
        do {
            try self.repo.deleteTopStories()
            exp.fulfill()
        } catch {
            XCTFail()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testDeleteTopStoriesFail() {
        let exp = XCTestExpectation()
        self.localDataSourceMock.removeAllResult = .fail(NSError(domain: "test", code: 1))
        do {
            try self.repo.deleteTopStories()
            XCTFail()
        } catch {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
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
