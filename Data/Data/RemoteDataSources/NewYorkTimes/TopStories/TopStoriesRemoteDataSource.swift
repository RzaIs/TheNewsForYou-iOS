//
//  TopStoriesRemoteDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 31.08.22.
//

class TopStoriesRemoteDataSource: TopStoriesRemoteDataSourceProtocol {
    
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }
    
    func getTopStories(segment: String) async throws -> BaseRemoteDTO<TopStoryRemoteDTO> {
        try await self.networkProvider.request(
            endpoint: TopStoriesAPI.getStories.rawValue.replacingOccurrences(of: "{segment}", with: segment),
            method: .get,
            headers: [:]
        )
    }
}
