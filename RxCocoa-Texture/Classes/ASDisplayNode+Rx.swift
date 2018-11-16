//
//  ASDisplayNode+Rx.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: ASDisplayNode {
    
    public var didLoad: Observable<Void> {
        
        return self.methodInvoked(#selector(Base.didLoad))
            .map { _ in return }
            .asObservable()
    }
    
    public var hide: ASBinder<Bool> {
        
        return ASBinder(self.base) { node, isHidden in
            node.isHidden = isHidden
        }
    }
    
    public var setNeedsLayout: Binder<Void> {
        
        return Binder(self.base) { node, _ in
            node.rx_setNeedsLayout()
        }
    }
}

extension Reactive where Base: ASDisplayNode {
    
    public var didEnterPreloadState: Observable<Void> {
        
        return self.methodInvoked(#selector(Base.didEnterPreloadState))
            .map { _ in return }
            .asObservable()
    }
    
    public var didEnterDisplayState: Observable<Void> {
        
        return self.methodInvoked(#selector(Base.didEnterDisplayState))
            .map { _ in return }
            .asObservable()
    }
    
    public var didEnterVisibleState: Observable<Void> {
        
        return self.methodInvoked(#selector(Base.didEnterVisibleState))
            .map { _ in return }
            .asObservable()
    }
    
    public var didExitVisibleState: Observable<Void> {
        
        return self.methodInvoked(#selector(Base.didExitVisibleState))
            .map { _ in return }
            .asObservable()
    }
    
    public var didExitDisplayState: Observable<Void> {
        
        return self.methodInvoked(#selector(Base.didExitDisplayState))
            .map { _ in return }
            .asObservable()
    }
    
    public var didExitPreloadState: Observable<Void> {
        
        return self.methodInvoked(#selector(Base.didEnterPreloadState))
            .map { _ in return }
            .asObservable()
    }
}

extension ASDisplayNode {
    
    /**
     setNeedsLayout with avoid block layout measure passing before node loaded
     
     - important: Block layout measure passing from rx.subscribe
     
     - returns: Void
     */
    public func rx_setNeedsLayout() {
        
        if self.isNodeLoaded {
            self.setNeedsLayout()
        } else {
            self.layoutIfNeeded()
            self.invalidateCalculatedLayout()
        }
    }
}
