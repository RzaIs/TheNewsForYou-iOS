//
//  MostPopularTest.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain
import XCTest
import Combine
@testable import Data

class MostPopularTest: XCTestCase {
    
    var cancelBag: Set<AnyCancellable> = .init()
    
    var remoteDataSourceMock: MostPopularRemoteDataSourceMock!
    var localDataSourceMock: MostPopularLocalDataSourceMock!
    var repo: MostPopularRepo!

    override func setUp() {
        self.remoteDataSourceMock = .init()
        self.localDataSourceMock = .init()
        self.repo = MostPopularRepo(
            localDataSource: self.localDataSourceMock,
            remoteDataSource: self.remoteDataSourceMock
        )
    }
    
    func testSyncTopStoriesSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.mostPopularResult = .success(BaseRemoteDTO(results: []))
        self.localDataSourceMock.saveResult = .success(Void())
        Task {
            do {
                try await self.repo.syncMostPopular()
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.localDataSourceMock.saveInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testSyncTopStoriesRemoteFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.mostPopularResult = .fail(NSError(domain: "test", code: 0))
        Task {
            do {
                try await self.repo.syncMostPopular()
            } catch {
                exp.fulfill()
            }
            XCTAssertNil(self.localDataSourceMock.saveInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testSyncTopStoriesLocalFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.mostPopularResult = .success(.init(results: []))
        self.localDataSourceMock.saveResult = .fail(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.repo.syncMostPopular()
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.localDataSourceMock.saveInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testObserveTopStories() {
        let exp = XCTestExpectation()
        self.repo.observeMostPopular.sink { mostPopular in
            XCTAssertEqual(mostPopular, self.localDataSourceMock.mostPopularMock.map { $0.toDomain })
            exp.fulfill()
        }.store(in: &self.cancelBag)

        self.localDataSourceMock.mostPopularPublisher.send(self.localDataSourceMock.mostPopularMock)
        wait(for: [exp], timeout: 1.0)
    }

    func testDeleteTopStoriesSuccess() {
        let exp = XCTestExpectation()
        self.localDataSourceMock.removeAllResult = .success(Void())
        do {
            try self.repo.deleteMostPopular()
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
            try self.repo.deleteMostPopular()
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
