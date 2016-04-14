//
//  Orb.swift
//  Rpgby
//
//  Created by James Carroll on 3/2/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit
import SpriteKit

// Class to handle orb sprites

final class Orb: Item {
  static let kName = "orb"
  static let kTextures = SKTextureAtlas(named: "orb")
  static let kRed = "red"
  static let kBlue = "blue"
  static let kProbRange = (0.0, 0.5)
  static let kInstance = Orb()
  static let kIndex = 0
  static let kCollectSfx = SKAction.playSoundFileNamed("Coin.mp3",
    waitForCompletion: false)
  
  private override init() {
    super.init(texture: Orb.kTextures.textureNamed(Orb.kRed))
  }
  
  override init(texture: SKTexture) {
    super.init(texture: texture)
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.anchorPointX(0)
    s.scale(0.035)
    s.physicsBody = SKPhysicsBody(circleOfRadius: s.size.width / 2)
    s.physicsBody?.categoryBitMask = Collision.kOrb
    setSharedProperties()
    s.name = Orb.kName
  }
}