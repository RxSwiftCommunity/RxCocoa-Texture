//
//  ASnode+Rx.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import UIKit

/** refer
 public static var normal: UIControlState { get }
 
 public static var highlighted: UIControlState { get } // used when UIControl isHighlighted is set
 
 public static var disabled: UIControlState { get }
 
 public static var selected: UIControlState { get } // flag usable by app (see below)
 **/

extension Reactive where Base: ASButtonNode {
    
    // apply attributedText on all control state
    public var attributedText: ASBinder<NSAttributedString?> {
        
        return ASBinder(self.base) { node, attributedText in
            self.setAllAttributedTitle(node, attributedText)
        }
    }
    
    // apply attributedText on targeted control state
    public func attributedText(_ controlState: UIControl.State) -> ASBinder<NSAttributedString?> {
        
        return ASBinder(self.base) { node, attributedText in
            node.setAttributedTitle(attributedText, for: controlState)
        }
    }
    
    // apply text with attribute on all control state
    public func text(_ attribute: [NSAttributedString.Key: Any]?) -> ASBinder<String?> {
        
        return ASBinder(self.base) { node, text in
            guard let text = text else {
                self.setAllAttributedTitle(node, nil)
                return
            }
            let attrText = NSAttributedString(string: text,
                                              attributes: attribute)
            self.setAllAttributedTitle(node, attrText)
        }
    }
    
    // apply text with attribute on targeted control state
    public func text(_ attribute: [NSAttributedString.Key: Any]?,
                     target: UIControl.State) -> ASBinder<String?> {
        
        return ASBinder(self.base) { node, text in
            guard let text = text else {
                node.setAttributedTitle(nil, for: target)
                return
            }
            let attrText = NSAttributedString(string: text,
                                              attributes: attribute)
            node.setAttributedTitle(attrText, for: target)
        }
    }
    
    // apply text with attributes
    public func text(applyList: [ASControlStateType]) -> ASBinder<String?> {
        
        return ASBinder(self.base) { node, text in
            guard let text = text else {
                for apply in applyList {
                    node.setAttributedTitle(nil,
                                            for: apply.state)
                }
                return
            }
            
            for apply in applyList {
                let attrText = NSAttributedString(string: text,
                                                  attributes: apply.attributes)
                node.setAttributedTitle(attrText,
                                        for: apply.state)
            }
        }
    }
    
    public var image: ASBinder<UIImage?> {
        
        return ASBinder(self.base) { node, image in
            self.setAllImage(node, image: image)
        }
    }
    
    public var backgroundImage: ASBinder<UIImage?> {
        
        return ASBinder(self.base) { node, image in
            self.setAllBackgroundImage(node, image: image)
        }
    }
    
    public func image(applyList: [ASControlStateType]) -> ASBinder<UIImage?> {
        
        return ASBinder(self.base) { node, image in
            
            guard let image = image  else {
                for apply in applyList {
                    node.setImage(nil, for: apply.state)
                }
                return
            }
            
            for apply in applyList {
                node.setImage(apply.image ?? image,
                              for: apply.state)
            }
        }
    }
    
    public func backgroundImage(applyList: [ASControlStateType]) -> ASBinder<UIImage?> {
        return ASBinder(self.base) { node, image in
            
            guard let image = image  else {
                for apply in applyList {
                    node.setBackgroundImage(nil, for: apply.state)
                }
                return
            }
            
            for apply in applyList {
                node.setBackgroundImage(apply.image ?? image,
                                        for: apply.state)
            }
        }
    }
    
    public enum ASControlStateType {
        
        case normal(Any?)
        case highlighted(Any?)
        case disabled(Any?)
        case selected(Any?)
        
        var state: UIControl.State {
            
            switch self {
            case .normal:
                return .normal
            case .highlighted:
                return .highlighted
            case .disabled:
                return .disabled
            case .selected:
                return .selected
            }
        }
        
        var url: URL? {
            
            switch self {
            case .normal(let attr):
                return attr as? URL
            case .highlighted(let attr):
                return attr as? URL
            case .disabled(let attr):
                return attr as? URL
            case .selected(let attr):
                return attr as? URL
            }
        }
        
        var image: UIImage? {
            
            switch self {
            case .normal(let attr):
                return attr as? UIImage
            case .highlighted(let attr):
                return attr as? UIImage
            case .disabled(let attr):
                return attr as? UIImage
            case .selected(let attr):
                return attr as? UIImage
            }
        }
        
        var attributes: [NSAttributedString.Key: Any]? {
            
            switch self {
            case .normal(let attr):
                return attr as? [NSAttributedString.Key: Any]
            case .highlighted(let attr):
                return attr as? [NSAttributedString.Key: Any]
            case .disabled(let attr):
                return attr as? [NSAttributedString.Key: Any]
            case .selected(let attr):
                return attr as? [NSAttributedString.Key: Any]
            }
        }
    }
    
    private func setAllAttributedTitle(_ node: ASButtonNode,
                                       _ attrText: NSAttributedString?) {
        
        node.setAttributedTitle(attrText, for: .normal)
        node.setAttributedTitle(attrText, for: .selected)
        node.setAttributedTitle(attrText, for: .highlighted)
        node.setAttributedTitle(attrText, for: .disabled)
    }
    
    private func setAllImage(_ node: ASButtonNode, image: UIImage?) {
        
        node.setImage(image, for: .normal)
        node.setImage(image, for: .selected)
        node.setImage(image, for: .highlighted)
        node.setImage(image, for: .disabled)
    }
    
    private func setAllBackgroundImage(_ node: ASButtonNode, image: UIImage?) {
        
        node.setBackgroundImage(image, for: .normal)
        node.setBackgroundImage(image, for: .selected)
        node.setBackgroundImage(image, for: .highlighted)
        node.setBackgroundImage(image, for: .disabled)
    }
}
