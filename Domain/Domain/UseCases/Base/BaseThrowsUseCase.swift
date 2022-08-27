//
//  BaseThrowsUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 27.08.22.
//

public class BaseThrowsUseCase<Input, Output> {
    public func execute(input: Input) throws -> Output {
        fatalError("Method Not Implemented")
    }
}
