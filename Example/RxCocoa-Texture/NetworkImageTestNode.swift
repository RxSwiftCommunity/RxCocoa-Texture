//
//  NetworkImageTestNode.swift
//
//  Created by Geektree0101.
//  Copyright(C) 2018 Geektree0101. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture

class NetworkImageTestNode: ASDisplayNode {
    
    /** ASNEtworkImageNode is ASControlNode subclass,
     so, you just use ASControlNode+RxExtension functions
     ref: ASControlNode+RxExtension
     **/

    lazy var imageNode = ASNetworkImageNode()
    let disposeBag = DisposeBag()
    let url = URL(string: "https://koreaboo-cdn.storage.googleapis.com/2017/08/sana-1-1.jpg")
    
    override init() {
        super.init()
        
        Observable.just(url)
            .bind(to: imageNode.rx.url)
            .disposed(by: disposeBag)
        
        Observable.just(url)
            .bind(to: imageNode.rx.url(resetToDefault: false))
            .disposed(by: disposeBag)
    }
}
