//
//  DefaultDataTransferErrorResolver.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    
    public init() { }
    
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}
