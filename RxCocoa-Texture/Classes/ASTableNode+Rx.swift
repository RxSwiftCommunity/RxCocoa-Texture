//
//  ASTableNode+Rx.swift
//
//  Created by Wendy Liga on 14/11/19.
//  Copyright © 2019 RxSwiftCommunity. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

public typealias PerformAction = (action: Selector, indexPath: IndexPath, sender: Any?)

extension Reactive where Base: ASTableNode {
    /**
        Reactive wrapper for `delegate`.

        For more information take a look at `DelegateProxyType` protocol documentation.
    */
    private var delegate: DelegateProxy<ASTableNode, ASTableDelegate> {
        return RxASTableDelegateProxy.proxy(for: base)
    }
    
    // MARK: - ASTableDelegate
    
    /**
     Reactive wrapper for `delegate` message `tableNode:didSelectRowAtIndexPath:`.
     */
    public var itemSelected: ControlEvent<IndexPath> {
        let source = self.delegate
            .methodInvoked(#selector(ASTableDelegate.tableNode(_:didSelectRowAt:)))
            .map { parameters -> IndexPath in
                guard let indexPath = parameters[1] as? IndexPath else {
                    throw(RxCocoaError.castingError(object: parameters[1], targetType: IndexPath.self))
                }
                
                return indexPath
            }
        
        return ControlEvent(events: source)
    }
    
   /**
    Reactive wrapper for `delegate` message `tableNode:didDeselectRowAtIndexPath:`.
    */
    public var itemDeselected: ControlEvent<IndexPath> {
       let source = self.delegate
           .methodInvoked(#selector(ASTableDelegate.tableNode(_:didDeselectRowAt:)))
           .map { parameters -> IndexPath in
               guard let indexPath = parameters[1] as? IndexPath else {
                   throw(RxCocoaError.castingError(object: parameters[1], targetType: IndexPath.self))
               }
               
               return indexPath
            }
       
       return ControlEvent(events: source)
    }
    
    /**
     Reactive wrapper for `delegate` message `tableNode:willDisplayRowWith:`.
     */
    public var willDisplayNode: ControlEvent<ASCellNode> {
        let source = self.delegate
            .methodInvoked(#selector(ASTableDelegate.tableNode(_:willDisplayRowWith:)))
            .map { parameters -> ASCellNode in
                guard let node = parameters[1] as? ASCellNode else {
                    throw(RxCocoaError.castingError(object: parameters, targetType: ASCellNode.self))
                }
                
                return node
            }
        
        return ControlEvent(events: source)
    }
    
    /**
     Reactive wrapper for `delegate` message `tableNode:didEndDisplayingRowWith:`.
     */
    public var didEndDisplayingNode: ControlEvent<ASCellNode> {
        let source = self.delegate
            .methodInvoked(#selector(ASTableDelegate.tableNode(_:didEndDisplayingRowWith:)))
            .map { parameters -> ASCellNode in
                guard let node = parameters[1] as? ASCellNode else {
                    throw(RxCocoaError.castingError(object: parameters, targetType: ASCellNode.self))
                }
                
                return node
            }
        
        return ControlEvent(events: source)
    }
    
    /**
     Reactive wrapper for `delegate` message `tableNode:didHighlightRowAt:`.
     */
    public var didHighlightRowAt: ControlEvent<IndexPath> {
        let source = self.delegate
            .methodInvoked(#selector(ASTableDelegate.tableNode(_:didHighlightRowAt:)))
            .map { parameters -> IndexPath in
                guard let node = parameters[1] as? IndexPath else {
                    throw(RxCocoaError.castingError(object: parameters, targetType: IndexPath.self))
                }
                
                return node
            }
        
        return ControlEvent(events: source)
    }
    
    /**
     Reactive wrapper for `delegate` message `tableNode:didUnhighlightRowAt:`.
     */
    public var didUnhighlightRowAt: ControlEvent<IndexPath> {
        let source = self.delegate
            .methodInvoked(#selector(ASTableDelegate.tableNode(_:didUnhighlightRowAt:)))
            .map { parameters -> IndexPath in
                guard let node = parameters[1] as? IndexPath else {
                    throw(RxCocoaError.castingError(object: parameters, targetType: IndexPath.self))
                }
                
                return node
            }
        
        return ControlEvent(events: source)
    }
    
    /**
     Reactive wrapper for `delegate` message `tableNode:willBeginBatchFetchWith:`.
     */
    public var willBeginBatchFetch: ControlEvent<ASBatchContext> {
        let source = self.delegate
            .methodInvoked(#selector(ASTableDelegate.tableNode(_:willBeginBatchFetchWith:)))
            .map { parameters -> ASBatchContext in
                guard let context = parameters[1] as? ASBatchContext else {
                    throw(RxCocoaError.castingError(object: parameters, targetType: ASBatchContext.self))
                }
                
                return context
            }
        
        return ControlEvent(events: source)
    }
}
