//
//  ASImageNode+RxExtensionSpec.swift
//
//  Created by Geektree0101.
//  Copyright(C) 2018 Geektree0101. All rights reserved.
//

import Quick
import Nimble
import RxTest
import RxSwift
import RxCocoa
import AsyncDisplayKit
@testable import RxCocoa_Texture

class ASImageNode_RxExtensionSpecSpec: QuickSpec {
    
    override func spec() {
        context("ASImageNode Reactive Extension  Unit Test") {
            let imageNode1 = ASImageNode()
            let imageNode2 = ASImageNode()
            let disposeBag = DisposeBag()
            
            beforeEach {
                Observable.just(#imageLiteral(resourceName: "texture_icon"))
                    .bind(to: imageNode1.rx.image)
                    .disposed(by: disposeBag)
                
                Observable.just(nil)
                    .bind(to: imageNode2.rx.image)
                    .disposed(by: disposeBag)
            }
            
            it("should be emit expected event") {
                expect(imageNode1.image).to(equal(#imageLiteral(resourceName: "texture_icon")))
                expect(imageNode2.image).to(beNil())
            }
        }
    }
}

