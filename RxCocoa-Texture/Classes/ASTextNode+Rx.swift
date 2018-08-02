//
//  ASTextNode+Rx.swift
//
//  Created by Geektree0101.
//  Copyright(C) 2018 Geektree0101. All rights reserved.
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

    public func text(_ attributes: [NSAttributedStringKey: Any]?) -> ASBinder<String?> {
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
