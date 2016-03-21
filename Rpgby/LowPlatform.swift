//
//  LowPlatform.swift
//  Orb
//
//  Created by James Carroll on 3/12/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class LowPlatform: Platform {
  static let kName = "LowPlatform"
  override var mName: String { return LowPlatform.kName }
  
  override init() {
    super.init(texture: Platform.kTextures.textureNamed(LowPlatform.kName))
    self.mBottom = true
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.anchorPointX(0)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(s.getMaxX(),
      s.getMaxY() - 10), center: s.getCenterPoint())
    self.setSharedProperties()
  }
}
