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

class EditableTextTestNode: ASDisplayNode {
    
    lazy var textNode = ASEditableTextNode()
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

