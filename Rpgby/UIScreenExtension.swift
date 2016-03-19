//
//  UIScreenExtension.swift
//  Orb
//
//  Created by James Carroll on 3/17/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit

// Helper funcs for UIScreen

extension UIScreen {
  static func scaleWidth(scale: Double) -> CGFloat {
    let w = UIScreen.mainScreen().bounds.width * CGFloat(scale)
    return w
  }
  
  static func scaleHeight(scale: Double) -> CGFloat {
    return UIScreen.mainScreen().bounds.height * CGFloat(scale)
  }
  
  static func scaleSize(width: Double, height: Double) -> CGSize {
    return CGSizeMake(scaleWidth(width), scaleHeight(height))
  }
  
  static func mainScreenScale() -> CGFloat {
    return UIScreen.mainScreen().scale
  }
}