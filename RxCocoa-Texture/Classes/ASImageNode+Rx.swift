//
//  ASImageNode+Rx.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension Reactive where Base: ASImageNode {

    public var image: ASBinder<UIImage?> {
        
        return ASBinder(self.base) { node, image in
            node.image = image
        }
    }
}
