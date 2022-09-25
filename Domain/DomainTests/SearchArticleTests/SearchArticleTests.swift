//
//  SearchArticleTests.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import XCTest
import Combine
@testable import Domain

class SearchArticleTests: XCTestCase {
    
    var cancelBag: Set<AnyCancellable> = .init()
    var repo: SearchArticleRepoMock!

    override func setUp() {
        self.repo = .init()
    }
    
    func testSearchArticleSuccess() {
        let exp = XCTestExpectation()
        let useCase = SearchArticleUseCase(repo: self.repo)
        self.repo.searchResult = .success(self.repo.searchDataMock)
        Task {
            do {
                let result = try await useCase.execute(input: "query")
                XCTAssertEqual(result, self.repo.searchDataMock)
                exp.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSearchArticleFail() {
        let exp = XCTestExpectation()
        let useCase = SearchArticleUseCase(repo: self.repo)
        self.repo.searchResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await useCase.execute(input: "query")
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

