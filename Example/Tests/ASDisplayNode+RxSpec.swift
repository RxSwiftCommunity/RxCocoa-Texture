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
            let disposeBag = DisposeBag()
            
            beforeEach {
                Observable.just(ASDimension(unit: .points, value: 17.0))
                    .bind(to: node1.rx.width)
                    .disposed(by: disposeBag)
                Observable.just(ASDimension(unit: .points, value: 15.0))
                    .bind(to: node1.rx.minWidth)
                    .disposed(by: disposeBag)
                Observable.just(ASDimension(unit: .points, value: 20.0))
                    .bind(to: node1.rx.maxWidth)
                    .disposed(by: disposeBag)
                Observable.just(ASDimension(unit: .points, value: 17.0))
                    .bind(to: node2.rx.height)
                    .disposed(by: disposeBag)
                Observable.just(ASDimension(unit: .points, value: 15.0))
                    .bind(to: node2.rx.minHeight)
                    .disposed(by: disposeBag)
                Observable.just(ASDimension(unit: .points, value: 20.0))
                    .bind(to: node2.rx.maxHeight)
                    .disposed(by: disposeBag)
                Observable.just(CGSize(width: 40.0, height: 40.0))
                    .bind(to: node3.rx.preferredSize)
                    .disposed(by: disposeBag)
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
        }
    }
}
