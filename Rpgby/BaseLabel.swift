//
//  BaseLabel.swift
//  Orb
//
//  Created by James Carroll on 3/10/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

class BaseLabel: SKLabelNode  {
  override var mName: String { return "BaseLabel" }
  
  override init() {
    super.init()
  }
  
  init(text: String) {
    super.init()
    
    self.text = text
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  override func createNode() {
    return
  }
}
