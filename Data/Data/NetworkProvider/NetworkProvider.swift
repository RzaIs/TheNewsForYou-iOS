//
//  NetworkProvider.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Alamofire

class NetworkProvider: NetworkProviderProtocol {
    
    private let baseURL: String
    private let APIKey: String
    private let logger: Logger
    private let session: Session
    
    init(baseURL: String,
         APIKey: String,
         logger: Logger,
         adapters: [RequestAdapter],
         retrier: [RequestRetrier]
    ) {
        self.baseURL = baseURL
        self.APIKey = APIKey
        self.logger = logger
        self.session = Session(
            interceptor: Interceptor(
                adapters: adapters,
                retriers: retrier
            )
        )
    }
    
    func fullUrl(endpoint: String) -> String {
        return "\(self.baseURL)/\(endpoint)".replacingOccurrences(of: "{APIKey}", with: self.APIKey)
    }
    
    func request<I: Encodable, O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws -> O {
        try await withUnsafeThrowingContinuation { continuation in
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
        headers: HTTPHeaders,
        encoder: ParameterEncoder
    ) async throws -> O {
        try await withUnsafeThrowingContinuation { continuation in
            let parameters: EmptyParameters? = nil
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
    
    func request<I: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws {
        return try await withUnsafeThrowingContinuation { continuation in
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
                    continuation.resume(throwing: NSError(domain: "Network-Request", code: 1))
                }
            }
        }
    }
    
    
    
}

class EmptyParameters: Codable {}
