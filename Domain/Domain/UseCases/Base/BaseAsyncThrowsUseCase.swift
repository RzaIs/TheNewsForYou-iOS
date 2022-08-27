//
//  BaseAsyncUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

public class BaseAsyncThrowsUseCase<Input, Output> {
    public func execute(input: Input) async throws -> Output {
        fatalError("Method Not Implemented")
    }
}
