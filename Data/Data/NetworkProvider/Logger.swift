//
//  Logger.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Foundation
import Alamofire

class Logger {
    private func log(info: String, type: LogType) {
        #if DEBUG
        
        switch type {
        case .url:
            print("[URL-ENDPOINT]: \(info)")
        case .response_body:
            print("[RESPONSE-BODY]: \(info)")
        case .request_body:
            print("[REQUEST-BODY]: \(info)")
        case .request_header:
            print("[REQUEST-HEADER]: \(info)")
        case .response_header:
            print("[RESPONSE-HEADER]: \(info)")
        case .error_body:
            print("[ERROR-BODY]: \(info)")
        }
        
        #endif
    }
    
    func log<T: Decodable>(response: DataResponse<T, AFError>) {
        if let url = response.request?.url {
            self.log(info: url.description, type: .url)
        } else if let data = response.data, let body = String(data: data, encoding: .utf8) {
            self.log(info: body, type: .response_body)
        } else if let header = response.response?.headers {
            self.log(info: header.description, type: .response_header)
        } else if let error = response.error {
            self.log(info: error.localizedDescription, type: .error_body)
        }
        
    }
}

enum LogType {
    case url, response_body, request_body, request_header, response_header, error_body
}
