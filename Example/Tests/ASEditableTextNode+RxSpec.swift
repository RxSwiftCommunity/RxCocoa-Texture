//
//  ASEditableTextNode+RxExtensionSpec.swift
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

class ASEditableTextNode_RxExtensionSpec: QuickSpec {
    
    override func spec() {
        
        context("ASEditableTextNode Reactive Extension  Unit Test") {
            
            let textNode1 = ASEditableTextNode()
            let textNode2 = ASEditableTextNode()
            let textNode3 = ASEditableTextNode()
            let textNode4 = ASEditableTextNode()
            
            let disposeBag = DisposeBag()
            
            beforeEach {
                Observable.just("apple")
                    .bind(to: textNode1.rx.text([:]))
                    .disposed(by: disposeBag)
                
                Observable.just(nil)
                    .bind(to: textNode2.rx.text([:]))
                    .disposed(by: disposeBag)
                
                Observable.just("banana")
                    .map({ NSAttributedString(string: $0) })
                    .bind(to: textNode3.rx.attributedText)
                    .disposed(by: disposeBag)
                
                Observable.just(nil)
                    .bind(to: textNode4.rx.attributedText)
                    .disposed(by: disposeBag)
            }
            
            it("should be emit expected event") {
                
                expect(textNode1.attributedText?.string).to(equal("apple"))
                expect(textNode2.attributedText?.string).to(beNil())
                expect(textNode3.attributedText?.string).to(equal("banana"))
                expect(textNode4.attributedText?.string).to(beNil())
            }
        }
    }
}


