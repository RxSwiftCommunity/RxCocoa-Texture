//
//  ButtonTestNode.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//


import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture

class ButtonTestNode: ASDisplayNode {
    
    /** ASButtonNode is ASControlNode subclass,
     so, you just use ASControlNode+RxExtension functions
     ref: ASControlNode+RxExtension
     **/
    lazy var buttonNode = ASButtonNode()
    let disposeBag = DisposeBag()
    let url = URL(string: "https://koreaboo-cdn.storage.googleapis.com/2017/08/sana-1-1.jpg")
    let touchRelay = PublishRelay<Void>()
    
    let defaultAttr = [NSAttributedString.Key.foregroundColor: UIColor.black]
    let disableAttr = [NSAttributedString.Key.foregroundColor: UIColor.gray]
    
    override init() {
        super.init()
        
        // tap event (ref: RxCocoa UIButton+Rx)
        buttonNode.rx.tap
            .subscribe()
            .disposed(by: disposeBag)
        
        // binding relay about tap event
        buttonNode.rx.tap(to: touchRelay)
            .disposed(by: disposeBag)
        
        // custom touch event
        buttonNode.rx.controlEvent(.touchUpInside)
            .subscribe()
            .disposed(by: disposeBag)
        
        Observable.just("you can bind text with attribute")
            .bind(to: buttonNode.rx.text(defaultAttr))
            .disposed(by: disposeBag)
        
        Observable.just("you can bind text with attribute and targeted control state")
            .bind(to: buttonNode.rx.text(disableAttr, target: .disabled))
            .disposed(by: disposeBag)
        
        Observable.just(NSAttributedString(string: "attributedText too"))
            .bind(to: buttonNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        Observable.just(NSAttributedString(string: "attributedText too"))
            .bind(to: buttonNode.rx.attributedText(.disabled))
            .disposed(by: disposeBag)
        
        Observable.just("you can apply text to various control state")
            .bind(to: buttonNode.rx
                .text(applyList: [.normal(defaultAttr),
                                  .disabled(disableAttr)]))
            .disposed(by: disposeBag)
        
        // set image
        Observable.just(#imageLiteral(resourceName: "texture_icon"))
            .bind(to: buttonNode.rx.image)
            .disposed(by: disposeBag)
        
        // set backgroundImage
        Observable.just(#imageLiteral(resourceName: "texture_icon"))
            .bind(to: buttonNode.rx.backgroundImage)
            .disposed(by: disposeBag)
        
        // set targeted control state image
        Observable.just(#imageLiteral(resourceName: "texture_icon"))
            .bind(to: buttonNode.rx
                .image(applyList: [.normal(nil),
                                   .disabled(#imageLiteral(resourceName: "Texture"))]))
            .disposed(by: disposeBag)
        
        // set targeted control state background-image
        Observable.just(#imageLiteral(resourceName: "texture_icon"))
            .bind(to: buttonNode.rx
                .backgroundImage(applyList: [.normal(nil),
                                             .disabled(#imageLiteral(resourceName: "texture_icon"))]))
            .disposed(by: disposeBag)
        
        
        Observable.just(false)
            .bind(to: buttonNode.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.just(false)
            .bind(to: buttonNode.rx.isEnabled)
            .disposed(by: disposeBag)
        
        Observable.just(false)
            .bind(to: buttonNode.rx.isHighlighted)
            .disposed(by: disposeBag)
        
        Observable.just(false)
            .bind(to: buttonNode.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
