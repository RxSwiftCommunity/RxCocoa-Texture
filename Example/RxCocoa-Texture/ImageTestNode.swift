//
//  ImageTestNode.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture

class ImageTestNode: ASDisplayNode {
    
    /** ASImageNode is ASControlNode subclass,
     so, you just use ASControlNode+RxExtension functions
     ref: ASControlNode+RxExtension
     **/

    lazy var imageNode = ASImageNode()
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        Observable.just(#imageLiteral(resourceName: "Texture"))
            .bind(to: imageNode.rx.image)
            .disposed(by: disposeBag)
    }
}
