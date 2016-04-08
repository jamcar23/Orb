//
//  Grass.swift
//  Orb
//
//  Created by James Carroll on 4/7/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class Grass: BaseSprite {
  static let kName = "Grass"
  static let kTextures = SKTextureAtlas(named: kName)
  static let kInstance = Grass()
  override var mName: String { return Grass.kName }
  
  var mGrassNodes = [SKSpriteNode]()
  var mPrevious = 0
  
  
  private override init() {
    super.init()
    Grass.kTextures.preloadWithCompletionHandler({Void in
      let texs = Grass.kTextures.toTextures()
      var s: SKSpriteNode!
      var p: SKPhysicsBody!
      
      for (i, t) in texs.enumerate() {
        s = SKSpriteNode(texture: t)
        s.name = Grass.kName + i.description
        p = SKPhysicsBody(texture: t, size: t.size())
        p.affectedByGravity = false
        p.dynamic = false
        s.physicsBody = p
        self.mGrassNodes.append(s)
      }
    })
  }
  
  func nextGrass(setAsPrevious: Bool) -> SKSpriteNode {
    var r = 0
    
    repeat {
      r = Int(arc4random_uniform(UInt32(mGrassNodes.count)))
    } while r == mPrevious
    
    if setAsPrevious {
      mPrevious = r
    }
    
    return mGrassNodes[r].copy() as! SKSpriteNode
  }
}