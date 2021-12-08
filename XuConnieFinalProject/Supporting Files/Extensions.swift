//
//  Extensions.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/16/21.
//

import Foundation
import UIKit

extension UIView {
    
    //width of frame
    var width: CGFloat {
        frame.size.width
    }
    
    //height of frame
    var height: CGFloat {
        frame.size.height
    }
    
    //left of frame
    var left: CGFloat {
        frame.origin.x
    }
    
    //right of frame
    var right: CGFloat {
        left + width
    }
    
    //top of frame
    var top: CGFloat {
        frame.origin.y
    }
    
    //bottom of frame
    var bottom: CGFloat {
        top + height
    }
}
