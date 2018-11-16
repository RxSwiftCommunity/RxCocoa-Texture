//
//  ASBinder.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

public struct ASBinder<Value>: ASObserverType {
    public typealias E = Value
    private let _binding: (Event<Value>, ASDisplayNode?) -> ()
    private var _directlyBinding: (Value?) -> ()
    
    public init<Target: AnyObject>(_ target: Target,
                                   scheduler: ImmediateSchedulerType = MainScheduler(),
                                   binding: @escaping (Target, Value) -> ()) {
        weak var weakTarget = target
        
        _directlyBinding = { value in
            if let target = weakTarget,
                let `value` = value {
                binding(target, value)
            }
        }
        
        _binding = { event, node in
            switch event {
            case .next(let element):
                _ = scheduler.schedule(element) { element in
                    if let target = weakTarget {
                        ASPerformBlockOnMainThread {
                           binding(target, element)
                        }
                    }
                    node?.rx_setNeedsLayout()
                    return Disposables.create()
                }
            case .error(let error):
                #if DEBUG
                    fatalError(error.localizedDescription)
                #else
                    print(error)
                #endif
            case .completed:
                break
            }
        }
    }
    
    public func on(_ event: Event<Value>, node: ASDisplayNode?) {
        _binding(event, node)
    }
    
    public func on(_ event: Event<Value>) {
        _binding(event, nil)
    }
    
    public func directlyBinding(_ element: Value?) {
        _directlyBinding(element)
    }
}

public protocol ASObserverType: ObserverType {
    func on(_ event: Event<E>, node: ASDisplayNode?)
    func directlyBinding(_ element: E?)
}

extension ObservableType {
    public func bind<O>(to observer: O,
                        directlyBind: Bool = false,
                        setNeedsLayout node: ASDisplayNode? = nil)
        -> Disposable where O : ASObserverType, Self.E == O.E {
            weak var weakNode = node
            
            if directlyBind, let value = (self as? BehaviorRelay<Self.E>)?.value {
                observer.directlyBinding(value)
            }
            
            return subscribe { event in
                switch event {
                case .next:
                    observer.on(event, node: weakNode)
                case .error(let error):
                    #if DEBUG
                        fatalError(error.localizedDescription)
                    #else
                        print(error)
                    #endif
                case .completed:
                    break
                }
            }
    }
    
    public func bind<O: ASObserverType>(to observer: O,
                                        directlyBind: Bool = false,
                                        setNeedsLayout node: ASDisplayNode? = nil)
        -> Disposable where O.E == E? {
            weak var weakNode = node
            
            if directlyBind, let value = (self as? BehaviorRelay<Self.E>)?.value {
                observer.directlyBinding(value)
            }
            
            return self.map { $0 }.subscribe { observerEvent in
                switch observerEvent {
                case .next:
                    observer.on(observerEvent.map({ Optional<Self.E>($0) }),
                                node: weakNode)
                case .error(let error):
                    #if DEBUG
                        fatalError(error.localizedDescription)
                    #else
                        print(error)
                    #endif
                case .completed:
                    break
                }
            }
    }
    
    public func bind(to relay: PublishRelay<E>,
                     directlyBind: Bool = false,
                     setNeedsLayout node: ASDisplayNode?) -> Disposable {
        weak var weakNode = node
        return subscribe { e in
            switch e {
            case let .next(element):
                relay.accept(element)
                weakNode?.setNeedsLayout()
            case let .error(error):
                let log = "Binding error to publish relay: \(error)"
                #if DEBUG
                    fatalError(log)
                #else
                    print(log)
                #endif
            case .completed:
                break
            }
        }
    }
    
    public func bind(to relay: PublishRelay<E?>,
                     directlyBind: Bool = false,
                     setNeedsLayout node: ASDisplayNode? = nil) -> Disposable {
        weak var weakNode = node
        return self.map { $0 as E? }
            .bind(to: relay, setNeedsLayout: weakNode)
    }
    
    public func bind(to relay: BehaviorRelay<E>,
                     directlyBind: Bool = false,
                     setNeedsLayout node: ASDisplayNode? = nil) -> Disposable {
        weak var weakNode = node
        return subscribe { e in
            switch e {
            case let .next(element):
                relay.accept(element)
                weakNode?.setNeedsLayout()
            case let .error(error):
                let log = "Binding error to behavior relay: \(error)"
                #if DEBUG
                    fatalError(log)
                #else
                    print(log)
                #endif
            case .completed:
                break
            }
        }
    }
    
    public func bind(to relay: BehaviorRelay<E?>,
                     setNeedsLayout node: ASDisplayNode? = nil) -> Disposable {
        weak var weakNode = node
        return self.map { $0 as E? }
            .bind(to: relay, setNeedsLayout: weakNode)
    }
}



