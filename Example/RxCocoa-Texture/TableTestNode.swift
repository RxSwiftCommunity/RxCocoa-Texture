//
//  TableTestNode.swift
//
//  Created by Wendy Liga on 14/11/19.
//  Copyright © 2019 RxSwiftCommunity. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture

class TableTestNode: ASDisplayNode {
    
    lazy var tableNode = ASTableNode()
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        self.tableNode.rx.itemSelected.subscribe(onNext: { indexPath in
            print(indexPath)
        }).disposed(by: disposeBag)
        
        self.tableNode.rx.itemDeselected.subscribe(onNext: { indexPath in
            print(indexPath)
        }).disposed(by: disposeBag)
        
        self.tableNode.rx.didHighlightRowAt.subscribe(onNext: { indexPath in
            print(indexPath)
        }).disposed(by: disposeBag)
        
        self.tableNode.rx.didUnhighlightRowAt.subscribe(onNext: { indexPath in
            print(indexPath)
        }).disposed(by: disposeBag)
        
        self.tableNode.rx.willDisplayNode.subscribe(onNext: { node in
            print(node)
        }).disposed(by: disposeBag)
        
        self.tableNode.rx.didEndDisplayingNode.subscribe(onNext: { node in
            print(node)
        }).disposed(by: disposeBag)
        
        self.tableNode.rx.willBeginBatchFetch.subscribe(onNext: { context in
            // execute your perform batch or reload data here
            context.completeBatchFetching(true)
        }).disposed(by: disposeBag)
    }
}
