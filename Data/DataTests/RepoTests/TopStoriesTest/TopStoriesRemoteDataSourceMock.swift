//
//  TopStoriesRemoteDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 21.09.22.
//

@testable import Data
import Domain
import Combine


class TopStoriesRemoteDataSourceMock: TopStoriesRemoteDataSourceProtocol {
    
    var mockSegment1: TopStoriesInput = .home
    var mockSegment2: TopStoriesInput = .arts
    var mockSegment3: TopStoriesInput = .science
    var mockSegment4: TopStoriesInput = .world
    var segmentInput: String? = nil
    
    var topStoriesMock: BaseRemoteDTO<TopStoryRemoteDTO> = .init(results: [])
    lazy var getTopStoriesResult: TopStoriesRemoteResult<BaseRemoteDTO<TopStoryRemoteDTO>> = .success(self.topStoriesMock)
    
    func getTopStories(segment: String) async throws -> BaseRemoteDTO<TopStoryRemoteDTO> {
        self.segmentInput = segment
        switch self.getTopStoriesResult {
        case .success(let data):
            return data
        case .fail(let error):
            throw error
        }
    }
}

enum TopStoriesRemoteResult<T> {
    case success(T)
    case fail(Error)
}
