//
//  ASButtonNode+RxExtensionSpec.swift
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
import UIKit
@testable import RxCocoa_Texture

class ASButtonNode_RxExtensionSpecSpec: QuickSpec {
    
    override func spec() {
        context("ASButtonNode Reactive Extension Unit Test") {
            let buttonNode = ASButtonNode()
            let testAttributedString = NSAttributedString.init(string: "apple")
            let testAttributedString2 = NSAttributedString.init(string: "banana")
            let testText = "cream"
            let testText2 = "dream"
            let disposedBag = DisposeBag()
            
            it("should be success bind attributedText") {
                Observable.just(testAttributedString)
                    .bind(to: buttonNode.rx.attributedText)
                    .disposed(by: disposedBag)
                
                expect(buttonNode.attributedTitle(for: .normal))
                    .to(equal(testAttributedString))
                expect(buttonNode.attributedTitle(for: .highlighted))
                    .to(equal(testAttributedString))
                expect(buttonNode.attributedTitle(for: .disabled))
                    .to(equal(testAttributedString))
                expect(buttonNode.attributedTitle(for: .selected))
                    .to(equal(testAttributedString))
                
                Observable.just(testAttributedString2)
                    .bind(to: buttonNode.rx.attributedText(.highlighted))
                    .disposed(by: disposedBag)
                
                expect(buttonNode.attributedTitle(for: .highlighted))
                    .toNot(equal(testAttributedString))
                expect(buttonNode.attributedTitle(for: .highlighted))
                    .to(equal(testAttributedString2))
                
                expect(buttonNode.attributedTitle(for: .normal))
                    .to(equal(testAttributedString))
                expect(buttonNode.attributedTitle(for: .disabled))
                    .to(equal(testAttributedString))
                expect(buttonNode.attributedTitle(for: .selected))
                    .to(equal(testAttributedString))
            }
            
            it("should be success bind text") {
                
                Observable.just(testText)
                    .bind(to: buttonNode.rx.text(nil))
                    .disposed(by: disposedBag)
                
                expect(buttonNode.attributedTitle(for: .normal)?.string == testText)
                    .to(beTrue())
                expect(buttonNode.attributedTitle(for: .highlighted)?.string == testText)
                    .to(beTrue())
                expect(buttonNode.attributedTitle(for: .disabled)?.string == testText)
                    .to(beTrue())
                expect(buttonNode.attributedTitle(for: .selected)?.string == testText)
                    .to(beTrue())
                
                Observable.just(testText2)
                    .bind(to: buttonNode.rx.text(nil, target: .disabled))
                    .disposed(by: disposedBag)
                
                expect(buttonNode.attributedTitle(for: .normal)?.string == testText)
                    .to(beTrue())
                expect(buttonNode.attributedTitle(for: .highlighted)?.string == testText)
                    .to(beTrue())
                expect(buttonNode.attributedTitle(for: .selected)?.string == testText)
                    .to(beTrue())
                
                expect(buttonNode.attributedTitle(for: .disabled)?.string == testText)
                    .to(beFalse())
                expect(buttonNode.attributedTitle(for: .disabled)?.string == testText2)
                    .to(beTrue())
                
                Observable.just(testText2)
                    .bind(to: buttonNode.rx.text(applyList: [.selected(nil),
                                                             .highlighted(nil)]))
                    .disposed(by: disposedBag)
                
                
                expect(buttonNode.attributedTitle(for: .normal)?.string == testText)
                    .to(beTrue())
                
                
                expect(buttonNode.attributedTitle(for: .selected)?.string == testText2)
                    .to(beTrue())
                expect(buttonNode.attributedTitle(for: .disabled)?.string == testText2)
                    .to(beTrue())
                expect(buttonNode.attributedTitle(for: .highlighted)?.string == testText2)
                    .to(beTrue())
            }
        }
    }
}

