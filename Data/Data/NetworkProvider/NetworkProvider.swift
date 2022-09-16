//
//  NetworkProvider.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Alamofire

class NetworkProvider: NetworkProviderProtocol {
    
    private let baseURL: String
    private let apiKey: String
    private let logger: Logger
    private let session: Session
    
    init(baseURL: String,
         apiKey: String,
         logger: Logger,
         adapters: [RequestAdapter],
         retriers: [RequestRetrier]
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.logger = logger
        self.session = Session(
            interceptor: Interceptor(
                adapters: adapters,
                retriers: retriers
            )
        )
    }
    
    func fullUrl(endpoint: String) -> String {
        return "\(self.baseURL)/\(endpoint)".replacingOccurrences(of: "{apiKey}", with: self.apiKey)
    }
    
    func request<I: Encodable, O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws -> O {
        try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                self.fullUrl(endpoint: endpoint),
                method: method,
                parameters: parameters,
                encoder: encoder,
                headers: headers
            ).responseDecodable(of: O.self) { response in
                self.logger.log(response: response)
                if let obj = response.value {
                    continuation.resume(returning: obj)
                } else if let error = response.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Network-Request", code: 1))
                }
            }
        }
    }
    
    func request<O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders
    ) async throws -> O {
        try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                self.fullUrl(endpoint: endpoint),
                method: method,
                parameters: nil,
                headers: headers
            ).responseDecodable(of: O.self) { response in
                self.logger.log(response: response)
                if let obj = response.value {
                    continuation.resume(returning: obj)
                } else if let error = response.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Network-Request", code: 2))
                }
            }
        }
    }
    
    func request<I: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                self.fullUrl(endpoint: endpoint),
                method: method,
                parameters: parameters,
                encoder: encoder,
                headers: headers
            ).response { response in
                self.logger.log(response: response)
                if let status = response.response?.statusCode, status >= 200, status <= 299 {
                    continuation.resume(returning: Void())
                } else if let error = response.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Network-Request", code: 4))
                }
            }
        }
    }
}

class EmptyParameters: Codable {}
