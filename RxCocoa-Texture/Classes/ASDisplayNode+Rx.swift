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

extension Reactive where Base: ASDisplayNode {
    
    public var width: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, width in
            node.style.width = width
        }
    }
    
    public var minWidth: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, minWidth in
            node.style.minWidth = minWidth
        }
    }
    
    public var maxWidth: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, maxWidth in
            node.style.maxWidth = maxWidth
        }
    }
    
    public var height: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, height in
            node.style.height = height
        }
    }
    
    public var minHeight: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, minHeight in
            node.style.minHeight = minHeight
        }
    }
    
    public var maxHeight: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, maxHeight in
            node.style.maxHeight = maxHeight
        }
    }
    
    public var preferredSize: ASBinder<CGSize> {
        return ASBinder(self.base) { node, preferredSize in
            node.style.preferredSize = preferredSize
        }
    }
    
    public var minSize: ASBinder<CGSize> {
        return ASBinder(self.base) { node, minSize in
            node.style.minSize = minSize
        }
    }
    
    public var maxSize: ASBinder<CGSize> {
        return ASBinder(self.base) { node, maxSize in
            node.style.maxSize = maxSize
        }
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
