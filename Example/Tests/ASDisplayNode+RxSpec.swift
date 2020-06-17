//
//  ASDisplayNode+RxSpec.swift
//
//  Created by Kanghoon
//  Copyright © 2019 RxSwiftCommunity. All rights reserved.
//

import Quick
import Nimble
import RxTest
import RxSwift
import RxCocoa
import AsyncDisplayKit
@testable import RxCocoa_Texture

class ASDisplayNode_RxExtensionSpec: QuickSpec {
    
    override func spec() {
        describe("ASDisplayNode") {
            let node1 = ASDisplayNode()
            let node2 = ASDisplayNode()
            let node3 = ASDisplayNode()
            let node4 = ASDisplayNode()
            
            beforeEach {
                node1.rx.width.onNext(ASDimension(unit: .points, value: 17.0))
                node1.rx.minWidth.onNext(ASDimension(unit: .points, value: 15.0))
                node1.rx.maxWidth.onNext(ASDimension(unit: .points, value: 20.0))
                
                node2.rx.height.onNext(ASDimension(unit: .points, value: 17.0))
                node2.rx.minHeight.onNext(ASDimension(unit: .points, value: 15.0))
                node2.rx.maxHeight.onNext(ASDimension(unit: .points, value: 20.0))
                
                node3.rx.preferredSize.onNext(CGSize(width: 40.0, height: 40.0))

                node4.rx.backgroundColor.onNext(.red)
                node4.rx.alpha.onNext(0.3)
                node4.rx.isUserInteractionEnabled.onNext(false)
            }
            
            it("should has correct width") {
                expect(node1.style.width.value).to(equal(17.0))
            }
            
            it("should has correct minWidth") {
                expect(node1.style.minWidth.value).to(equal(15.0))
            }
            
            it("should has correct maxWidth") {
                expect(node1.style.maxWidth.value).to(equal(20.0))
            }
            
            it("should has correct height") {
                expect(node2.style.height.value).to(equal(17.0))
            }
            
            it("should has correct minHeight") {
                expect(node2.style.minHeight.value).to(equal(15.0))
            }
            
            it("should has correct maxHeight") {
                expect(node2.style.maxHeight.value).to(equal(20.0))
            }
            
            it("should has correct preferredSize") {
                expect(node3.style.preferredSize).to(equal(CGSize(width: 40.0, height: 40.0)))
            }

            it("should has correct backgroundColor") {
                expect(node4.backgroundColor).to(equal(.red))
            }
            
            it("should has correct alpha") {
                expect(node4.alpha).to(equal(0.3))
            }
            
            it("should has correct isUserInteractionEnabled") {
                expect(node4.isUserInteractionEnabled).to(equal(false))
            }
        }
    }
}
