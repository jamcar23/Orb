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
  
  // Set a random elevation between the screen height and the point where 
  // the sprite touches the bottom
  // TODO fix y
  
  private func randomElevation() {
    let s = self.mSprite
    let y = CGFloat(arc4random_uniform(UInt32((s.scene?.frame.height) ??
      0))) + s.halfHeight()
    s.position.y = y
  }
  
  // Set a random distance to jump within a certain margin
  // TODO tweak x
  
  private func randomDistance(previous: CGFloat, width: CGFloat) {
    let p = Player.kInstance
    let max = calcXDistance(sin: 45, cos: 45)
    let min = p.mSprite.size.width * 1.5
    let x = calcRandom(upper: max, lower: 0, min: min)
    let w = width * 1.1
    self.mSprite.position.x = (x < width ? x : calcRandom(upper: width + w,
      lower: 0, min: width - w))  + previous
  }
  
  private func calcXDistance(sin s: CGFloat, cos c: CGFloat) -> CGFloat {
    return (((2 * Player.kInstance.mMovement) ^^ 2) * sin(s) * cos(c)) / 4.2
  }
  
  // Calcs a random number between upper and lower plus the minimum
  
  private func calcRandom(upper u: CGFloat, lower l: CGFloat, min m: CGFloat) -> CGFloat {
    return CGFloat(arc4random_uniform(UInt32(u - l))) + l + m
  }
  
  // Public to call for setting the position
  
  func setPosition(previous: CGFloat, width: CGFloat) {
    if previous != -1 {
      randomDistance(previous, width: width)
    }
    
    mBottom ? self.mSprite.bottom() : randomElevation()
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
