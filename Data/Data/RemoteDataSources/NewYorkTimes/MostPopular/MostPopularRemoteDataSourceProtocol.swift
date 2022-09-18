//
//  MostPopularRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 11.09.22.
//

protocol MostPopularRemoteDataSourceProtocol {
    var getMostPopular: BaseRemoteDTO<MostPopularRemoteDTO> { get async throws  }
}
