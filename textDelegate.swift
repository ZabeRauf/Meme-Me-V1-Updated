//
//  textDelegate.swift
//  Dank experiments
//
//  Created by Zabe Rauf on 9/21/17.
//  Copyright © 2017 Zaben. All rights reserved.
//

import UIKit

class textDelegate: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let memeTextAttributes: [String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName: -1]

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let textStyle = memeTextAttributes
        
        // Construct text in the field assigned.
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        if memeTextAttributes.count > 0 {
            textField.defaultTextAttributes = textStyle
        }
        
        //if colorsInTheText.count > 0 {
        //    textField.textColor = self.blendColorArray(colorsInTheText)
        //}
        // textField.text = memeTextAttributes
        
        return true
    }

}
