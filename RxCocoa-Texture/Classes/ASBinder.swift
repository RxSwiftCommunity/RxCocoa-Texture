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
    
    func on(_ event: Event<Element>, node: ASDisplayNode?)
    func directlyBinding(_ element: Element?)
}

extension ObservableType {
    
    public func bind(
        to relays: PublishRelay<Element>...,
        setNeedsLayout node: ASDisplayNode?) -> Disposable {
        
        return bind(to: relays, setNeedsLayout: node)
    }
    
    public func bind(
        to relays: PublishRelay<Element?>...,
        setNeedsLayout node: ASDisplayNode?) -> Disposable {
        
        return self.map { $0 as Element? }.bind(to: relays, setNeedsLayout: node)
    }
    
    private func bind(
        to relays: [PublishRelay<Element>],
        setNeedsLayout node: ASDisplayNode?) -> Disposable {
        
        weak var weakNode = node
        
        return subscribe { e in
            switch e {
            case let .next(element):
                relays.forEach {
                    $0.accept(element)
                }
                weakNode?.rx_setNeedsLayout()
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
    
    public func bind(
        to relays: BehaviorRelay<Element>...,
        setNeedsLayout node: ASDisplayNode?) -> Disposable {
        
        return self.bind(to: relays, setNeedsLayout: node)
    }
    
    public func bind(
        to relays: BehaviorRelay<Element?>...,
        setNeedsLayout node: ASDisplayNode?) -> Disposable {
        
        return self.map { $0 as Element? }.bind(to: relays, setNeedsLayout: node)
    }
    
    private func bind(
        to relays: [BehaviorRelay<Element>],
        setNeedsLayout node: ASDisplayNode?) -> Disposable {
        
        weak var weakNode = node
        
        return subscribe { e in
            switch e {
            case let .next(element):
                relays.forEach {
                    $0.accept(element)
                }
                weakNode?.rx_setNeedsLayout()
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
}

extension ObservableType {
    
    public func bind<Observer: ASObserverType>(
        to observers: Observer...,
        setNeedsLayout node: ASDisplayNode? = nil) -> Disposable where Observer.Element == Element {
        
        return self.bind(
            to: observers,
            setNeedsLayout: node
        )
    }
    
    public func bind<Observer: ASObserverType>(
        to observers: Observer...,
        setNeedsLayout node: ASDisplayNode? = nil) -> Disposable where Observer.Element == Element? {
        
        return self.map { $0 as Element? }
            .bind(
                to: observers,
                setNeedsLayout: node
        )
    }
    
    private func bind<Observer: ASObserverType>(
        to observers: [Observer],
        setNeedsLayout node: ASDisplayNode? = nil) -> Disposable where Observer.Element == Element {
        
        weak var weakNode = node
        
        return self.subscribe { event in
            observers.forEach {
                $0.on(event, node: weakNode)
            }
        }
    }
}
