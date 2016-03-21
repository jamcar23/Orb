//
//  SmallPlatform.swift
//  Orb
//
//  Created by James Carroll on 3/12/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class SmallPlatform: Platform {
  static let kName = "SmallPlatform"
  override var mName: String { return SmallPlatform.kName }
  
  override init() {
    super.init(texture: Platform.kTextures.textureNamed(SmallPlatform.kName))
    self.mBottom = false
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.scale(0.85)
    s.anchorPointX(0)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: s.size, center: s.getCenterPoint())
    self.setSharedProperties()
  }
}