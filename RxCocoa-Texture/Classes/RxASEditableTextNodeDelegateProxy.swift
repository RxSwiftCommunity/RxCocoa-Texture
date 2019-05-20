//
//  RxASEditableTextNodeDelegateProxy.swift
//  RxCocoa-Texture
//
//  Created by KanghoonOh on 20/05/2019.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension ASEditableTextNode: HasDelegate {
    public typealias Delegate = ASEditableTextNodeDelegate
}

open class RxASEditableTextNodeDelegateProxy
    : DelegateProxy<ASEditableTextNode, ASEditableTextNodeDelegate>
    , DelegateProxyType
    , ASEditableTextNodeDelegate {
    
    public weak private(set) var editableTextNode: ASEditableTextNode?
    
    public init(editableTextNode: ASEditableTextNode) {
        self.editableTextNode = editableTextNode
        super.init(parentObject: editableTextNode,
                   delegateProxy: RxASEditableTextNodeDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxASEditableTextNodeDelegateProxy(editableTextNode: $0) }
    }
}
