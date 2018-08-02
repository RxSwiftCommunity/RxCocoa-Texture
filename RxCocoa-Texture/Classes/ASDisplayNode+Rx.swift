//
//  ASDisplayNode+Rx.swift
//
//  Created by Geektree0101.
//  Copyright(C) 2018 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: ASDisplayNode {
    
    public var hide: ASBinder<Bool> {
        return ASBinder(self.base) { node, isHidden in
            node.isHidden = isHidden
        }
    }
    
    public var didLoad: Observable<Void> {
        return self.methodInvoked(#selector(Base.didLoad))
            .map { _ in return }
            .asObservable()
    }
}
