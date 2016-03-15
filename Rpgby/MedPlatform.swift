//
//  MedPlatform.swift
//  Orb
//
//  Created by James Carroll on 3/12/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class MedPlatform: Platform {
  static let kName = "MedPlatform"
  override var mName: String { return MedPlatform.kName }
  
  init() {
    super.init(texture: Platform.kTextures.textureNamed(MedPlatform.kName))
    self.mBottom = true
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.scale(0.5)
    s.anchorPointX(0)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: s.size, center: s.getCenterPoint())
    self.setSharedProperties()
  }
}
