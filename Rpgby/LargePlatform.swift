//
//  LargePlatform.swift
//  Orb
//
//  Created by James Carroll on 3/8/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

class LargePlatform: Platform {
  static let kName = "LargePlatform"
  override var mName: String { return LargePlatform.kName }
  
  init() {
    super.init(textureName: LargePlatform.kName)
    self.mBottom = false
  }
  
  override func createSprite() {
    self.mSprite.scale(0.7)
    self.mSprite.anchorPointX(0)
    self.mSprite.physicsBody = SKPhysicsBody(rectangleOfSize: self.mSprite.size)
    self.mSprite.name = LargePlatform.kName
    self.setSharedProperties()
  }
}
