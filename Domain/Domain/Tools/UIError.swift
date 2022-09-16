//
//  UIError.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

public struct UIError: Error {
    public let title: String
    public let message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
