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

final class Orb: BaseSprite {
  static let kName = "orb"
  static let kTextures = SKTextureAtlas(named: "orb")
  static let kRed = "red"
  static let kBlue = "blue"
  static let kProbablity = 0.5
  static let kInstance = Orb()
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
    s.physicsBody?.collisionBitMask = Collision.kPlatform
    s.physicsBody?.contactTestBitMask = Collision.kPerson
    s.physicsBody?.restitution = 0.2
    s.name = Orb.kName
    s.zPosition = Spacing.kPersonOrbZIndex
  }
  
  func setPosition(platform: SKSpriteNode) {
    let s = self.mSprite
    let x = platform.position.x
    let r = Physics.kInstance.calcRandom(platform.getMaxX(),
      lower: x, min: 0)
    
    s.position = CGPointMake(r - s.halfWidth(), platform.getMaxY())
  }
}