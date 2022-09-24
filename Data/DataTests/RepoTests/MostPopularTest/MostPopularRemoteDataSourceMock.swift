//
//  MostPopularRemoteDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

@testable import Data

class MostPopularRemoteDataSourceMock: MostPopularRemoteDataSourceProtocol {
    
    var mostPopularResult: MostPopularRemoteResult<BaseRemoteDTO<MostPopularRemoteDTO>> = .success(.init(results: []))
    
    var getMostPopular: BaseRemoteDTO<MostPopularRemoteDTO> {
        get async throws {
            switch self.mostPopularResult {
            case .success(let result):
                return result
            case .fail(let error):
                throw error
            }
        }
    }
}

enum MostPopularRemoteResult<T> {
    case success(T)
    case fail(Error)
}
