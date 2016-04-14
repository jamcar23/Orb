//
//  Wings.swift
//  Orb
//
//  Created by James Carroll on 4/14/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class Wings: Item {
  static let kName = "Wings"
  static let kTextures = SKTextureAtlas(named: kName)
  static let kProbRange = (0.7, 0.9)
  static let kIndex = 2
  static let kInstance = Wings()
  static let kWingTimer = Wings.createFlightTimer()
  
  private override init() {
    super.init(texture: Wings.kTextures.textureNamed("Wing"))
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.scale(0.3)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: s.size, center: s.getCenterPoint())
    s.physicsBody?.categoryBitMask = Collision.kWing
    setSharedProperties()
    s.name = Wings.kName
  }
  
  private static func createFlightTimer() -> SKAction {
    let w = SKAction.waitForDuration(10)
    let r = SKAction.runBlock({ Void in
      let p = Player.kInstance
      
      p.removeWings()
    })
    
    return SKAction.sequence([w, r])
  }
}

