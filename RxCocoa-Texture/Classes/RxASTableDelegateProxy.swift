//
//  RxASTableDelegateProxy.swift
//
//  Created by Wendy Liga on 14/11/2019.
//  Copyright © 2019 RxSwiftCommunity. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension ASTableNode: HasDelegate {
    public typealias Delegate = ASTableDelegate
}

open class RxASTableDelegateProxy: DelegateProxy<ASTableNode, ASTableDelegate>, DelegateProxyType, ASTableDelegate {
    
    /// Typed parent object.
    public private(set) weak var tableNode: ASTableNode?
    
    public init(tableNode: ASTableNode) {
        self.tableNode = tableNode
        super.init(parentObject: tableNode, delegateProxy: RxASTableDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        register { RxASTableDelegateProxy(tableNode: $0) }
    }
}
