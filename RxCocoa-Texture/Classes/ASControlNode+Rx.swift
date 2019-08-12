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

    /// Creates a `ControlProperty` that is triggered by target/action pattern value updates.
    ///
    /// - parameter controlEvents: ASControlNodeEvents that trigger value update sequence elements.
    /// - parameter getter: Property value getter.
    /// - parameter setter: Property value setter.
    public func controlProperty<T>(
        editingEvents: ASControlNodeEvent,
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> ()
    ) -> ControlProperty<T> {
        let source: Observable<T> = Observable.create { [weak weakControl = base] observer in
            guard let control = weakControl else {
                observer.on(.completed)
                return Disposables.create()
            }

            observer.on(.next(getter(control)))

            let controlTarget = ASControlTarget(control, editingEvents) { _ in
                if let control = weakControl {
                    observer.on(.next(getter(control)))
                }
            }

            return Disposables.create(with: controlTarget.dispose)
        }
        .takeUntil(deallocated)

        let bindingObserver = ASBinder(base, binding: setter)

        return ControlProperty<T>(values: source, valueSink: bindingObserver)
    }
    
    public var tap: ControlEvent<Void> {
        
        let source = self.controlEvent(.touchUpInside).map { _ in return }
        return ControlEvent(events: source)
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
    
    public var isHighlighted: ControlProperty<Bool> {

        return self.controlProperty(
            editingEvents: [.touchDown, .touchUpInside, .touchCancel],
            getter: { control in
                control.isHighlighted
            },
            setter: { control, isHighlighted in
                control.isHighlighted = isHighlighted
            }
        )
    }
    
    public var isSelected: ASBinder<Bool> {
        
        return ASBinder(self.base) { node, isSelected in
            node.isSelected = isSelected
        }
    }
}
