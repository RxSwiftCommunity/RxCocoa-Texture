//
//  ASTableNode+RxSpec.swift
//
//  Created by Wendy Liga on 14/11/19.
//  Copyright © 2019 RxSwiftCommunity. All rights reserved.
//

import Quick
import Nimble
import RxTest
import RxBlocking
import RxSwift
import RxCocoa
import AsyncDisplayKit
@testable import RxCocoa_Texture

class ASTableNode_RxExtensionSpec: QuickSpec {
    
    var tableNode: ASTableNode!
    
    lazy var cellNodes: [ASCellNode] = {
        return data.map { index -> ASCellNode in
            let node = ASCellNode()
            node.accessibilityIdentifier = "\(index)"
            
            return node
        }
    }()
    
    var data: [Int] {
        return (0...10).map { $0 }
    }
    
    override func spec() {
        beforeEach {
            self.tableNode = ASTableNode()
            self.tableNode.dataSource = self
            self.tableNode.reloadData()
        }
        context("table node item selected") {
            it("should be emit expected event and triggered inside reactive wrapper") {
                let disposedBag = DisposeBag()
                let scheduler = TestScheduler.init(initialClock: 0)
                
                let targetToObserve = scheduler.createObserver(IndexPath.self)
                self.tableNode.rx.itemSelected.subscribe(targetToObserve).disposed(by: disposedBag)
                            
                // test emit
                let emitObserver = scheduler
                    .createColdObservable([.next(100, IndexPath(item: 1, section: 0)),
                                           .next(200, IndexPath(item: 3, section: 0)),
                                           .next(300, IndexPath(item: 2, section: 0))])
                
                emitObserver.subscribe(onNext: { [weak self] event in
                    guard let self = self else {
                        XCTFail("self reference is missing")
                        return
                    }
                    
                    // stimulate delegate, on real UI app, it will automatically trigger it.
                    self.tableNode.selectRow(at: event, animated: true, scrollPosition: .middle)
                    self.tableNode.delegate?.tableNode?(self.tableNode, didSelectRowAt: event)
                }).disposed(by: disposedBag)
                
                scheduler.start()
                
                XCTAssertEqual(targetToObserve.events, [
                    .next(100, IndexPath(item: 1, section: 0)),
                    .next(200, IndexPath(item: 3, section: 0)),
                    .next(300, IndexPath(item: 2, section: 0))
                ])
            }
        }
        
        context("table node item deselected") {
            it("should be emit expected event and triggered inside reactive wrapper") {
                let disposedBag = DisposeBag()
                let scheduler = TestScheduler.init(initialClock: 0)
                
                let targetToObserve = scheduler.createObserver(IndexPath.self)
                self.tableNode.rx.itemDeselected.subscribe(targetToObserve).disposed(by: disposedBag)
                            
                // test emit
                let emitObserver = scheduler
                    .createColdObservable([.next(100, IndexPath(item: 1, section: 0)),
                                           .next(200, IndexPath(item: 3, section: 0)),
                                           .next(300, IndexPath(item: 2, section: 0))])
                
                emitObserver.subscribe(onNext: { [weak self] event in
                    guard let self = self else {
                        XCTFail("self reference is missing")
                        return
                    }
                    
                    // stimulate delegate, on real UI app, it will automatically trigger it.
                    self.tableNode.deselectRow(at: event, animated: true)
                    self.tableNode.delegate?.tableNode?(self.tableNode, didDeselectRowAt: event)
                }).disposed(by: disposedBag)
                
                scheduler.start()
                
                XCTAssertEqual(targetToObserve.events, [
                    .next(100, IndexPath(item: 1, section: 0)),
                    .next(200, IndexPath(item: 3, section: 0)),
                    .next(300, IndexPath(item: 2, section: 0))
                ])
            }
        }
        
        context("table node will display node") {
            
        }
    }
}

extension ASTableNode_RxExtensionSpec: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cell = cellNodes[indexPath.row]
        
        return { [cell] in
            return cell
        }
    }
}


