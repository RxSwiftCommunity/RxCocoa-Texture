//
//  ASRenderModelIdentifier.swift
//
//  Created by Geektree0101.
//  Copyright(C) 2018 Geektree0101. All rights reserved.
//

import Foundation

public struct ASRenderModelIdentifier: Equatable {
    public typealias RMID = ASRenderModelIdentifier
    let identifier: String
    
    public init<T: ASRenderModelProtocol>(_ id: Any, type: T.Type) {
        self.identifier = "Identifier-\(type)-\(id)"
    }
    
    public static func == (_ lhs: RMID, _ rhs: RMID) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

public protocol ASRenderModelProtocol {
    var renderModelIdentifier: ASRenderModelIdentifier { get }
}
