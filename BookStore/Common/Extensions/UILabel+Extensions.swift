//
//  UILabel+Extensions.swift
//  BookStore
//
//  Created by Mariana V. A. Souza on 03/07/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import UIKit

extension UILabel
{
    var optimalHeight : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            
            label.sizeToFit()
            
            return label.frame.height
        }
    }
}
