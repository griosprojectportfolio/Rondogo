//
//  PickerTextField.swift
//  PoliticsMoe
//
//  Created by GrepRuby3 on 04/02/16.
//  Copyright © 2016 GrepRuby. All rights reserved.
//

import Foundation
import UIKit

class PickerTextField : UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        return newBounds
    }
    
}