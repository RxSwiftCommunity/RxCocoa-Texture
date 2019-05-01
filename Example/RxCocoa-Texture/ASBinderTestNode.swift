//
//  ASBinderTestNode.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxCocoa_Texture
import RxSwift
import RxCocoa

class ASBinderTestNode: ASDisplayNode {
    
    let textNode =  ASTextNode()
    let imageNode = ASNetworkImageNode()
    
    let textNode2 =  ASTextNode()
    let imageNode2 = ASNetworkImageNode()
    
    let disposeBag = DisposeBag()
    let url = URL(string: "https://koreaboo-cdn.storage.googleapis.com/2017/08/sana-1-1.jpg")
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        
        Observable.just(url)
            .bind(to: imageNode.rx.url, setNeedsLayout: self)
            .disposed(by: disposeBag)
        
        Observable.just(Optional<String>("optional text"))
            .bind(to: textNode.rx.text(nil), setNeedsLayout: self)
            .disposed(by: disposeBag)
        
        Driver.just(url)
            .drive(imageNode2.rx.url, setNeedsLayout: self)
            .disposed(by: disposeBag)
        
        Driver.just(Optional<String>("optional test"))
            .drive(textNode2.rx.text(nil), setNeedsLayout: self)
            .disposed(by: disposeBag)
    }
}
