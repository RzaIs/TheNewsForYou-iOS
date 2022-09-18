//
//  MostPopularRemoteDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 11.09.22.
//

class MostPopularRemoteDataSource: MostPopularRemoteDataSourceProtocol {
    
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }
    
    var getMostPopular: BaseRemoteDTO<MostPopularRemoteDTO> {
        get async throws {
            try await self.networkProvider.request(
                endpoint: MostPopularAPI.getPopular.rawValue,
                method: .get,
                headers: [:],
                retry: true
            )
        }
    }
}
