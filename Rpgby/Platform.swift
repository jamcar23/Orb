//
//  Platform.swift
//  Orb
//
//  Created by James Carroll on 3/8/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

// Code all platforms share

class Platform: BaseSprite {
  static let kAllPlatforms = Platform.createPlatforms()
  static let kTextures = SKTextureAtlas(named: "world")
  override var mName: String { return "Platform" }
  var mBottom = true
  
  // Handle setting up everything platforms share
  
  func setSharedProperties() {
    let s = self.mSprite
    
    s.physicsBody?.dynamic = false
    s.physicsBody?.restitution = 0
    s.physicsBody?.affectedByGravity = false
    s.physicsBody?.friction = 0.75
    s.physicsBody?.categoryBitMask = Collision.kPlatform
    s.physicsBody?.collisionBitMask = Collision.kOrb
    s.physicsBody?.contactTestBitMask = Collision.kPerson
    
    s.zPosition = Spacing.kPlatformZIndex
    s.anchorPoint.x = 0
  }
  
  // Public to call for setting the position
  
  func setPosition(previous: CGFloat, size: CGSize) {
    let p = Physics.kInstance
    
    if previous >= 0 {
      p.randomDistance(sprite: self.mSprite, previous: previous, width:
        size.width, time: nil)
    }
    
    p.randomElevation(sprite: self.mSprite, height: size.height, bottom: mBottom,
      time: nil)
  }
  
  func setOrb(orb: SKSpriteNode) {
    let s = self.mSprite
    let x = s.position.x
    let r = Physics.kInstance.calcRandom(getMaxX(), lower: orb.halfWidth(), min:
      x)
    orb.position = CGPointMake(r, getMaxY())
  }
  
  // MARK: - Static methods
  
  static func createPlatforms() -> [Platform] {
    var all = [Platform]()
    
    all.append(MainPlatform())
    all.append(LargePlatform())
    all.append(SmallPlatform())
    all.append(LowPlatform())
    all.append(MedPlatform())
    
    for a in all {
      a.createNode()
    }
    
    return all
  }
  
  static func nextPlatform(pervious: Int) -> (Int, Platform) {
    var r = 0
    
    repeat {
      r = Int(arc4random_uniform(UInt32(Platform.kAllPlatforms.count)))
    } while r == pervious
    
    return (r, Platform.kAllPlatforms[r])
  }
  
}
