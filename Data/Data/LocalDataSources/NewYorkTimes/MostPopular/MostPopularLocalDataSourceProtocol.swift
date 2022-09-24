//
//  MostPopularLocalDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 11.09.22.
//

import Combine

protocol MostPopularLocalDataSourceProtocol {
    func removeAll() throws
    func save(mostPopular: [MostPopularLocalDTO]) throws
    func observeMostPopular() -> AnyPublisher<[MostPopularLocalDTO], Never>
}
