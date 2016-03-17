//
//  Blur.swift
//  Orb
//
//  Created by James Carroll on 3/17/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit

class BlurView: UIVisualEffectView {
  static let kInstance = BlurView()
  
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */
  
  private init() {
    super.init(effect: UIBlurEffect(style: .Light))
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func fInit() {
    
  }
}
