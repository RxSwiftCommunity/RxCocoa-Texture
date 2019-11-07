//
//  Driver+ASSubscription.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

private let errorMessage = "`drive*` family of methods can be only called from `MainThread`.\n" +
"This is required to ensure that the last replayed `Driver` element is delivered on `MainThread`.\n"

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    public func drive<O: ASObserverType>(_ observer: O,
                                         directlyBind: Bool = false,
                                         setNeedsLayout node: ASDisplayNode? = nil) -> Disposable where O.Element == Element {
        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
        return self.asSharedSequence()
            .asObservable()
            .bind(to: observer,
                  setNeedsLayout: node)
    }
    
    public func drive<O: ASObserverType>(_ observer: O,
                                         directlyBind: Bool = false,
                                         setNeedsLayout node: ASDisplayNode? = nil) -> Disposable where O.Element == Element? {
        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
        return self.asSharedSequence()
            .asObservable()
            .map { $0 as Element? }
            .bind(to: observer,
                  setNeedsLayout: node)
    }
}
