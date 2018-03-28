//
//  CustomTextField.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 25/03/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var placeHolderColor : UIColor? {
        didSet {
            let attrString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: attrString, attributes: [NSForegroundColorAttributeName: placeHolderColor!])
            attributedPlaceholder = str
            
        }
    }

}
