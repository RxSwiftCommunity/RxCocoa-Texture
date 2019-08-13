//
//  ASControlNode+RxExtensionSpec.swift
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

class ASControlNode_RxExtensionSpecSpec: QuickSpec {
    
    // refer: http://texturegroup.org/docs/node-overview.html
    override func spec() {
        
        context("ASControlNode Reactive Extension Test") {
            
            let controlNode = ASControlNode()
            let disposedBag = DisposeBag()
            
            it("should be emit expected event") {
                let scheduler = TestScheduler.init(initialClock: 0)
                
                let emitObserver = scheduler
                    .createHotObservable([next(100, ASControlNodeEvent.touchUpInside),
                                          next(200, ASControlNodeEvent.touchDown),
                                          next(300, ASControlNodeEvent.touchUpOutside),
                                          next(400, ASControlNodeEvent.touchDragInside),
                                          next(500, ASControlNodeEvent.touchCancel)])
                // etc
                
                emitObserver.subscribe(onNext: { event in
                    controlNode.sendActions(forControlEvents: event, with: nil)
                }).disposed(by: disposedBag)
                
                let outputEvent = scheduler
                    .record(controlNode.rx.controlEvent(.touchUpInside)
                        .map { _ -> ASControlNodeEvent in return .touchUpInside })
                let outputEvent2 = scheduler
                    .record(controlNode.rx.controlEvent(.touchDown)
                        .map { _ -> ASControlNodeEvent in return .touchDown })
                let outputEvent3 = scheduler
                    .record(controlNode.rx.controlEvent(.touchUpOutside)
                        .map { _ -> ASControlNodeEvent in return .touchUpOutside})
                let outputEvent4 = scheduler
                    .record(controlNode.rx.controlEvent(.touchDragInside)
                        .map { _ -> ASControlNodeEvent in return .touchDragInside })
                let outputEvent5 = scheduler
                    .record(controlNode.rx.controlEvent(.touchCancel)
                        .map { _ -> ASControlNodeEvent in return .touchCancel })
                
                scheduler.start()
                
                let expectEvent: [Recorded<Event<ASControlNodeEvent>>] = [
                    next(100, .touchUpInside)
                ]
                
                let expectEvent2: [Recorded<Event<ASControlNodeEvent>>] = [
                    next(200, .touchDown)
                ]
                
                let expectEvent3: [Recorded<Event<ASControlNodeEvent>>] = [
                    next(300, .touchUpOutside)
                ]
                
                let expectEvent4: [Recorded<Event<ASControlNodeEvent>>] = [
                    next(400, .touchDragInside)
                ]
                
                let expectEvent5: [Recorded<Event<ASControlNodeEvent>>] = [
                    next(500, .touchCancel)
                ]
                
                XCTAssertEqual(outputEvent.events, expectEvent)
                XCTAssertEqual(outputEvent2.events, expectEvent2)
                XCTAssertEqual(outputEvent3.events, expectEvent3)
                XCTAssertEqual(outputEvent4.events, expectEvent4)
                XCTAssertEqual(outputEvent5.events, expectEvent5)
            }
            
            it("should be emit tap event") {
                
                let scheduler = TestScheduler.init(initialClock: 0)
                
                let emitObserver = scheduler
                    .createHotObservable([next(100, ()),
                                          next(200, ()),
                                          next(300, ())])
                
                emitObserver.subscribe(onNext: { _ in
                    controlNode.sendActions(forControlEvents: .touchUpInside, with: nil)
                }).disposed(by: disposedBag)
                
                let outputEvent = scheduler
                    .record(controlNode.rx.tap.map { _ in return true })
                
                scheduler.start()
                
                let expectEvent: [Recorded<Event<Bool>>] = [
                    next(100, true),
                    next(200, true),
                    next(300, true)
                ]
                
                XCTAssertEqual(outputEvent.events, expectEvent)
            }
            
            it("should be emit relay tap event") {
                
                let scheduler = TestScheduler.init(initialClock: 0)
                let emitter = PublishRelay<Void>()
                let accepter: Observable<Bool>
                
                accepter = emitter.map { _ in return true }.asObservable()
                
                let emitObserver = scheduler
                    .createHotObservable([next(100, ()),
                                          next(200, ()),
                                          next(300, ())])
                
                emitObserver.subscribe(onNext: { _ in
                    controlNode.sendActions(forControlEvents: .touchUpInside, with: nil)
                }).disposed(by: disposedBag)
                
                controlNode.rx.tap(to: emitter).disposed(by: disposedBag)
                
                let outputEvent = scheduler.record(accepter)
                
                scheduler.start()
                
                let expectEvent: [Recorded<Event<Bool>>] = [
                    next(100, true),
                    next(200, true),
                    next(300, true)
                ]
                
                XCTAssertEqual(outputEvent.events, expectEvent)
            }
            
            it("should be hidden/show") {
                
                Observable.just(true)
                    .bind(to: controlNode.rx.isHidden)
                    .disposed(by: disposedBag)
                
                expect(controlNode.isHidden).to(beTrue())
                
                Observable.just(false)
                    .bind(to: controlNode.rx.isHidden)
                    .disposed(by: disposedBag)
                
                expect(controlNode.isHidden).to(beFalse())
            }
            
            it("should be enable/disable") {
                
                Observable.just(true)
                    .bind(to: controlNode.rx.isEnabled)
                    .disposed(by: disposedBag)
                
                expect(controlNode.isEnabled).to(beTrue())
                
                Observable.just(false)
                    .bind(to: controlNode.rx.isEnabled)
                    .disposed(by: disposedBag)
                
                expect(controlNode.isEnabled).to(beFalse())
                
            }
            
            it("should be highlight/unhighlight") {
                
                Observable.just(true)
                    .bind(to: controlNode.rx.isHighlighted)
                    .disposed(by: disposedBag)
                
                expect(controlNode.isHighlighted).to(beTrue())
                
                Observable.just(false)
                    .bind(to: controlNode.rx.isHighlighted)
                    .disposed(by: disposedBag)
                
                expect(controlNode.isHighlighted).to(beFalse())
            }

            it("should observe highlight/unhighlight") {
                final class UITouchStub: UITouch {
                    private let _tapCount: Int
                    override var tapCount: Int {
                        return self._tapCount
                    }

                    override init() {
                        self._tapCount = 1 // becaused of ASControlNode.touchesBegan(_:with:)
                        super.init()
                    }
                }

                // given
                var isHighlighted: Bool = false
                controlNode.isEnabled = true
                controlNode.rx.isHighlighted
                    .subscribe(onNext: { isHighlighted = $0 })
                    .disposed(by: disposedBag)

                // when & then - Touch down/up/cancel
                controlNode.touchesBegan([UITouchStub()], with: nil)
                expect(isHighlighted).to(beTrue())

                controlNode.touchesBegan([UITouchStub()], with: nil)
                controlNode.touchesEnded([UITouchStub()], with: nil)
                expect(isHighlighted).to(beFalse())

                controlNode.touchesBegan([UITouchStub()], with: nil)
                controlNode.touchesCancelled([UITouchStub()], with: nil)
                expect(isHighlighted).to(beFalse())
            }
            
            it("should be selected/non-selected") {
                
                Observable.just(true)
                    .bind(to: controlNode.rx.isSelected)
                    .disposed(by: disposedBag)
                
                expect(controlNode.isSelected).to(beTrue())
                
                Observable.just(false)
                    .bind(to: controlNode.rx.isSelected)
                    .disposed(by: disposedBag)
                
                expect(controlNode.isSelected).to(beFalse())
            }
        }
    }
}

extension TestScheduler {
    /// Creates a `TestableObserver` instance which immediately subscribes
    /// to the `source` and disposes the subscription at virtual time 100000.
    func record<O: ObservableConvertibleType>(_ source: O) -> TestableObserver<O.E> {
        let observer = self.createObserver(O.E.self)
        let disposable = source.asObservable().bind(to: observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }
}

