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
        
        tableNode.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }
}
