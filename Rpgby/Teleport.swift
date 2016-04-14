//
//  Teleport.swift
//  Orb
//
//  Created by James Carroll on 4/14/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class Teleport: Item {
  static let kName = "Teleport"
  static let kTextures = SKTextureAtlas(named: kName)
  static let kProbRange = (0.9, 1.0)
  static let kIndex = 1
  static let kInstance = Teleport()
  
  private override init() {
    super.init(texture: Teleport.kTextures.textureNamed("light"))
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.physicsBody = SKPhysicsBody(rectangleOfSize: s.size, center: s.getCenterPoint())
    s.physicsBody?.categoryBitMask = Collision.kTeleport
    setSharedProperties()
    s.name = Teleport.kName
  }
}
