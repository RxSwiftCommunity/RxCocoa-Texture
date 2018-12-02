//
//  ASTextNode+Rx.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension Reactive where Base: ASTextNode {
    
    public var attributedText: ASBinder<NSAttributedString?> {
        
        return ASBinder(self.base) { node, attributedText in
            node.attributedText = attributedText
        }
    }

    public func text(_ attributes: [NSAttributedString.Key: Any]?) -> ASBinder<String?> {
        
        return ASBinder(self.base) { node, text in
            guard let text = text else {
                node.attributedText = nil
                return
            }
            
            node.attributedText = NSAttributedString(string: text,
                                                     attributes: attributes)
        }
    }
}
