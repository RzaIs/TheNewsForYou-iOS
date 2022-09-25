//
//  SearchArticleTest.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain
import XCTest
import Combine
@testable import Data

class SearchArticleTest: XCTestCase {
    
    var remoteDataSourceMock: SearchArticleRemoteDataSourceMock!
    var repo: SearchArticleRepo!
    
    override func setUp() {
        self.remoteDataSourceMock = .init()
        self.repo = SearchArticleRepo(
            remoteDataSource: self.remoteDataSourceMock
        )
    }
    
    func testSearchArticleSuccess() {
        let exp = XCTestExpectation()
        let mockResult: SearchDataRemoteDTO = .init(data: [])
        self.remoteDataSourceMock.getSearchArticleResult = .success(mockResult)
        Task {
            do {
                let result = try await self.repo.search(query: self.remoteDataSourceMock.queryMock)
                XCTAssertEqual(mockResult.result.map { $0.toDomain }, result)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.getSearchArticleInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSearchArticleFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.getSearchArticleResult = .fail(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await self.repo.search(query: self.remoteDataSourceMock.queryMock)
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.getSearchArticleInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
}

extension SearchArticleEntity: Equatable {
    public static func == (lhs: SearchArticleEntity, rhs: SearchArticleEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.author == rhs.author &&
        lhs.abstract == rhs.abstract &&
        lhs.sectionName == rhs.sectionName &&
        lhs.subsectionName == rhs.subsectionName &&
        lhs.multimedia == rhs.multimedia &&
        lhs.publishDate == rhs.publishDate &&
        lhs.url == rhs.url
    }
}
