//
//  ASNetworkImageNode+RxExtensionSpec.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Quick
import Nimble
import RxTest
import RxSwift
import RxCocoa
import AsyncDisplayKit
@testable import RxCocoa_Texture

class ASNetworkImageNode_RxExtensionSpecSpec: QuickSpec {
    
    override func spec() {
        
        context("ASNetworkImageNode Reactive Extension  Unit Test") {
            
            var url: URL!
            let imageNode1 = ASNetworkImageNode()
            let imageNode2 = ASNetworkImageNode()
            
            let disposeBag = DisposeBag()
            
            beforeEach {
                url = URL(string: "https://koreaboo-cdn.storage.googleapis.com/2017/08/sana-1-1.jpg")
                Observable.just(url)
                    .bind(to: imageNode1.rx.url)
                    .disposed(by: disposeBag)
                
                Observable.just(nil)
                    .bind(to: imageNode2.rx.url)
                    .disposed(by: disposeBag)
            }
            
            it("should be emit expected event") {
                expect(imageNode1.url).to(equal(url))
                expect(imageNode2.url).to(beNil())
            }
        }
    }
}

