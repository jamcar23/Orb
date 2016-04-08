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
  static let kTextures = SKTextureAtlas(named: "Platforms")
  override var mName: String { return "Platform" }
  var mBottom = true
  
  // Handle setting up everything platforms share
  
  func setSharedProperties(size: CGSize) {
    let s = self.mSprite
    
    s.anchorPointX(0)
    s.scale(0.75)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: size, center:
      s.getCenterPoint())
    s.physicsBody?.dynamic = false
    s.physicsBody?.restitution = 0
    s.physicsBody?.affectedByGravity = false
    s.physicsBody?.friction = 0.75
    s.physicsBody?.categoryBitMask = Collision.kPlatform
    s.physicsBody?.collisionBitMask = Collision.kOrb
    s.physicsBody?.contactTestBitMask = Collision.kPerson
    
    s.zPosition = Spacing.kPlatformZIndex
  }
  
  // Public to call for setting the position
  
  func setPosition(previous: CGRect?, size: CGSize) {
    let p = Physics.kInstance
    let x = previous?.getMaxX() ?? -1
    let y = previous?.getMaxY() ?? 0
    
    if x >= 0 {
      p.randomDistance(sprite: self.mSprite, previous: x, width:
        size.width, time: nil)
    } else if previous == nil {
      self.mSprite.position = self.mSprite.anchorPoint
    }
    
    p.randomElevation(sprite: self.mSprite, height: y, bottom: mBottom,
      time: nil)
  }
  
  // Set the orbs position releative to the platform
  
  func setOrb(orb: SKSpriteNode) {
    let s = self.mSprite
    let x = s.position.x
    let r = Physics.kInstance.calcRandom(getMaxX(), lower: orb.halfWidth(), min:
      x - orb.halfWidth())
    orb.position = CGPointMake(r, getMaxY())
  }
  
  // MARK: - Static methods
  
  static func createPlatforms() -> [Platform] {
    var all = [Platform]()
    
    all.append(FluffyPlatform())
    all.append(FluffyPlatform2())
    all.append(SmallPlatform())
    all.append(MedPlatform())
    all.append(SmallPlatform2())
    
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
