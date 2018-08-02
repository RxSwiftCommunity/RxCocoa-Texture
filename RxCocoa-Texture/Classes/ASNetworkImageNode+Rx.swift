//
//  ASNetworkImageNode+Rx.swift
//
//  Created by Geektree0101.
//  Copyright(C) 2018 Geektree0101. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension Reactive where Base: ASNetworkImageNode {
    
    public var url: ASBinder<URL?> {
        return ASBinder(self.base) { node, url in
            node.setURL(url, resetToDefault: true)
        }
    }
    
    public func url(resetToDefault: Bool) -> ASBinder<URL?> {
        return ASBinder(self.base) { node, url in
            node.setURL(url, resetToDefault: resetToDefault)
        }
    }
}

