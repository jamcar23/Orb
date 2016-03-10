//
//  Player.swift
//  Rpgby
//
//  Created by James Carroll on 3/2/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation
import SpriteKit

// Class to handle player sprite
// Singleton because there's only one player.

final class Player: BaseSprite {
  static let kName = "player"
  static let kInstance = Player()
  static let kRunTex = SKTextureAtlas(named: "running")
  static let kJumpTex = SKTextureAtlas(named: "jump")
  static let kJumpSfx = SKAction.playSoundFileNamed("sfx-jump.mp3",
    waitForCompletion: false)
  
  var mJumping = false
  var mMovement: CGFloat = 8
  var mRunAni: SKAction!
  var mJumpUpAni: SKAction!
  var mJumpDownAni: SKAction!
  private var mBaseY: CGFloat = 0
  private var mJumpY: CGFloat!
  
  private init() {
    super.init(textureName: "idle-1")
    Player.kRunTex.preloadWithCompletionHandler({
      self.mRunAni = SKAction.animateWithTextures(Player.kRunTex.toTextures(),
      timePerFrame: 0.06)
    })
    
    Player.kJumpTex.preloadWithCompletionHandler({
      let texs = Player.kJumpTex.toTextures()
        
      self.mJumpUpAni = SKAction.animateWithTextures([texs[1]], timePerFrame: 0,
        resize: false, restore: true)
      self.mJumpDownAni = SKAction.animateWithTextures([texs[0]], timePerFrame:
      0, resize: false, restore: true)
    })
  }
  
  // Starts the running animation
  
  func beginRunning() {
    self.mSprite.runAction(SKAction.repeatActionForever(mRunAni))
  }
  
  // Handles jumping animation and movement
  
  func beginJumping() {
    let phy = self.mSprite.physicsBody
    
    if !mJumping { // single jump only
      mJumping = true
      mBaseY = self.mSprite.position.y
      self.mSprite.removeAllActions()
//      self.mSprite.runAction(Player.kJumpSfx)
      self.mSprite.runAction(mJumpUpAni)
      phy?.applyImpulse(CGVectorMake(phy!.velocity.dx, mJumpY))
    }
  }
  
  // Handles falling animation
  
  func endJumping() {
    let y = self.mSprite.position.y
    
    if y >= mBaseY + mJumpY {
      self.mSprite.runAction(mJumpDownAni)
    }
  }
  
  override func createSprite() {
    self.mSprite.scale(0.075)
    self.mSprite.anchorPointX(0)
    self.mSprite.position = CGPointMake(30, 500)
    self.mSprite.physicsBody = SKPhysicsBody(rectangleOfSize: self.mSprite.size)
    self.mSprite.physicsBody?.categoryBitMask = Collision.kPerson
    self.mSprite.physicsBody?.collisionBitMask = Collision.kPlatform
    self.mSprite.physicsBody?.contactTestBitMask = Collision.kOrb
    self.mSprite.physicsBody?.allowsRotation = false
    self.mSprite.name = Player.kName
    self.mSprite.zPosition = Spacing.kPersonOrbZIndex
    
    self.mJumpY = 300 * self.mSprite.physicsBody!.mass
  }
}