//
//  Logger.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Foundation
import Alamofire

class Logger {
    
    let encoder = JSONEncoder()
    
    init() {
        self.encoder.outputFormatting = .prettyPrinted
    }
    
    private func log(error: Error) {
    #if DEBUG
    print("\t[ERROR-BODY]: \(error)")
    #endif
    }
    
    private func log(info: String, type: LogType) {
        #if DEBUG
        
        switch type {
        case .start:
            print("[START]: \(info)")
        case .end:
            print("[END]: \(info)")
        case .url:
            print("\t[URL-ENDPOINT]: \(info)")
        case .status_code:
            print("\t[STATUS_CODE]: \(info)")
        case .response_body:
            print("\t[RESPONSE-BODY]: \(info)")
        case .request_body:
            print("\t[REQUEST-BODY]: \(info)")
        case .request_header:
            print("\t[REQUEST-HEADER]: \(info)")
        case .response_header:
            print("\t[RESPONSE-HEADER]: \(info)")
        case .error_body:
            print("\t[ERROR-BODY]: \(info)")
        }
        
        #endif
    }
    
    func log<T: Decodable>(response: DataResponse<T, AFError>) {
        self.log(info: "", type: .start)
        if let url = response.request?.url {
            self.log(info: url.path, type: .url)
        }
        if let statusCode = response.response?.statusCode {
            self.log(info: statusCode.description, type: .status_code)
        }
        if let data = response.data, let body = data.prettyJSON {
            self.log(info: body, type: .response_body)
        }
        if let headers = response.response?.headers {
            self.log(info: headers.description, type: .response_header)
        }
        if let error = response.error {
            self.log(error: error)
        }
        self.log(info: "", type: .end)
    }
    
    func log(request: URLRequest) {
        self.log(info: "", type: .start)
        if let url = request.url {
            self.log(info: url.path, type: .url)
        }
        if let body = request.httpBody, let json = body.prettyJSON {
            self.log(info: json, type: .request_body)
        }
        self.log(info: request.headers.description, type: .request_header)
        self.log(info: "", type: .end)
    }
}

enum LogType {
    case start, end, url, status_code, response_body, request_body, request_header, response_header, error_body
}

extension Data {
    var prettyJSON: String? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
