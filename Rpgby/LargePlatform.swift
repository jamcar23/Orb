//
//  LargePlatform.swift
//  Orb
//
//  Created by James Carroll on 3/8/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class LargePlatform: Platform {
  static let kName = "LargePlatform"
  override var mName: String { return LargePlatform.kName }
  
  init() {
    super.init(texture: Platform.kTextures.textureNamed(LargePlatform.kName))
    self.mBottom = false
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.scale(0.7)
    s.anchorPointX(0)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: s.size,
      center: self.getCenterPoint())
    s.name = LargePlatform.kName
    self.setSharedProperties()
  }
}
