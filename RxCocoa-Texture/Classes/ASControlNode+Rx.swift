//
//  ASControlNode+Rx.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//


import AsyncDisplayKit
import RxSwift
import RxCocoa

extension Reactive where Base: ASControlNode {
    
    /// Reactive wrapper for target action pattern.
    ///
    /// - parameter controlEvents: Filter for observed ASControlNodeEvent types.
    public func controlEvent(_ controlEvents: ASControlNodeEvent) -> ControlEvent<Base> {
        
        let source: Observable<Base> = Observable
            .create { [weak control = self.base] observer in
                MainScheduler.ensureExecutingOnScheduler()
                
                guard let control = control else {
                    observer.on(.completed)
                    return Disposables.create()
                }
                
                let controlTarget = ASControlTarget(control, controlEvents) { control in
                    observer.on(.next(control))
                }
                
                return Disposables.create(with: controlTarget.dispose)
            }
            .takeUntil(deallocated)
        
        return ControlEvent(events: source)
    }
    
    public var tap: Observable<Void> {
        
        return self.controlEvent(.touchUpInside).map { _ in return }
    }
    
    public func tap(to relay: PublishRelay<()>) -> Disposable {
        
        return self.controlEvent(.touchUpInside)
            .map { _ in return }
            .asSignal(onErrorJustReturn: ())
            .emit(to: relay)
    }
    
    public var isHidden: ASBinder<Bool> {
        
        return ASBinder(self.base) { node, isHidden in
            node.isHidden = isHidden
        }
    }
    
    public var isEnabled: ASBinder<Bool> {
        
        return ASBinder(self.base) { node, isEnabled in
            node.isEnabled = isEnabled
        }
    }
    
    public var isHighlighted: ASBinder<Bool> {
        
        return ASBinder(self.base) { node, isHighlighted in
            node.isHighlighted = isHighlighted
        }
    }
    
    public var isSelected: ASBinder<Bool> {
        
        return ASBinder(self.base) { node, isSelected in
            node.isSelected = isSelected
        }
    }
}
