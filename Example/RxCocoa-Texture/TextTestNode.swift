//
//  TestTestNode.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture

class TextTestNode: ASDisplayNode {
    
    /** ASTextNode is ASControlNode subclass,
     so, you just use ASControlNode+RxExtension functions
     ref: ASControlNode+RxExtension
     **/
    
    lazy var textNode = ASTextNode()
    let disposeBag = DisposeBag()
    static let attribute = [NSAttributedString.Key.foregroundColor: UIColor.gray]
    
    override init() {
        super.init()
        
        Observable.just("text")
            .bind(to: textNode.rx.text(TextTestNode.attribute))
            .disposed(by: disposeBag)
        
        Observable.just("text")
            .map { NSAttributedString(string: $0, attributes: TextTestNode.attribute) }
            .bind(to: textNode.rx.attributedText)
            .disposed(by: disposeBag)
    }
}
