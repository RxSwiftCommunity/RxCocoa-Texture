//
//  BinderAndDriver+RxSpec.swift
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

class BinderAndDriver_RxExtensionSpec: QuickSpec {
    
    override func spec() {
        
        var disposeBag = DisposeBag()
        
        describe("Bind Test") {
            let textNode = ASTextNode()
            let textNode2 = ASTextNode()
            let textNode3 = ASTextNode()
            
            beforeEach {
                disposeBag = DisposeBag()
                
                Observable.just("test")
                    .bind(to: textNode.rx.text(nil), setNeedsLayout: nil)
                    .disposed(by: disposeBag)
                
                Observable.just("test2")
                    .bind(to: textNode2.rx.text(nil), setNeedsLayout: nil)
                    .disposed(by: disposeBag)
                
                Observable.just("test3")
                    .bind(to: textNode3.rx.text(nil), setNeedsLayout: nil)
                    .disposed(by: disposeBag)
            }
            
            it("should be bind estimated value") {
                
                expect(textNode.attributedText!.string).to(equal("test"))
                expect(textNode2.attributedText!.string).to(equal("test2"))
                expect(textNode3.attributedText!.string).to(equal("test3"))
            }
        }
        
        describe("Drive Test") {
            let textNode = ASTextNode()
            let textNode2 = ASTextNode()
            let textNode3 = ASTextNode()
            
            beforeEach {
                disposeBag = DisposeBag()
                
                Driver.just("test")
                    .drive(textNode.rx.text(nil), setNeedsLayout: nil)
                    .disposed(by: disposeBag)
                
                Driver.just("test2")
                    .drive(textNode2.rx.text(nil), setNeedsLayout: nil)
                    .disposed(by: disposeBag)
                
                Driver.just("test3")
                    .drive(textNode3.rx.text(nil), setNeedsLayout: nil)
                    .disposed(by: disposeBag)
            }
            
            it("should be drive estimated value") {
                
                expect(textNode.attributedText!.string).to(equal("test"))
                expect(textNode2.attributedText!.string).to(equal("test2"))
                expect(textNode3.attributedText!.string).to(equal("test3"))
            }
        }
    }
}
