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
  static let kTimer = "timer"
  static let kJumpTimer = "jumpTimer"
  static let kInstance = Player()
  static let kRunTex = SKTextureAtlas(named: "running")
  static let kJumpTex = SKTextureAtlas(named: "jump")
  static let kJumpSfx = SKAction.playSoundFileNamed("sfx-jump.mp3",
    waitForCompletion: false)
  static let kFallSfx = SKAction.playSoundFileNamed("sfx-fall.mp3",
    waitForCompletion: false)
  
  var mJumping = false
  var mCounting = false
  var mTeleporting = false
  var mRunAni: SKAction!
  var mJumpUpAni: SKAction!
  var mJumpDownAni: SKAction!
  var mJumpTimeAct: SKAction!
  private var mBaseY: CGFloat = 0
  var mJumpY: CGFloat = 0
  var mTime: CGFloat = 0.001
  var mOldSize: (player: CGSize!, wing: CGSize?)
  var mTeleportPos: CGFloat = 0
  var mWings: SKSpriteNode?
  
  private override init() {
    super.init(texture: SKTexture(imageNamed: "idle-1"))
    Player.kRunTex.preloadWithCompletionHandler({
      self.mRunAni = SKAction.animateWithTextures(Player.kRunTex.toTextures(),
        timePerFrame: 0.06)
    })
    
    Player.kJumpTex.preloadWithCompletionHandler({
      let texs = Player.kJumpTex.toTextures()
      
      self.mJumpUpAni = SKAction.animateWithTextures([texs[1]], timePerFrame: 0,
        resize: false, restore: false)
      self.mJumpDownAni = SKAction.animateWithTextures([texs[0]], timePerFrame:
        0, resize: false, restore: false)
      
      self.mOldSize = (player: self.mSprite.size, wing: nil)
    })
    
    self.mJumpTimeAct = createJumpTimerAction()
  }
  
  // Starts the running animation
  
  func beginRunning() {
    self.mSprite.runAction(SKAction.repeatActionForever(mRunAni))
  }
  
  func startJumpTimer() {
    let s = self.mSprite
    
    if !mJumping { // single jump only
      mJumping = true
      mBaseY = s.position.y
      self.mTime = 1
      s.runAction(mJumpTimeAct, withKey: Player.kJumpTimer)
      self.mCounting = true
    }
  }
  
  // Handles jumping animation and movement
  
  func beginJumping() {
    let s = self.mSprite
    let phy = Physics.kInstance
    let phyBody = s.physicsBody
    let t = phy.calcTime(self.mTime)
    
    if mCounting {
      mCounting = false
      s.removeAllActions()
      s.runAction(Player.kJumpSfx)
      s.runAction(mJumpUpAni)
//      let x = phy.calcXDistance(45, time: t)
      mJumpY = phy.calcYDistance(45, time: t)
      print("jumpY: " + mJumpY.description)
      phyBody?.applyImpulse(CGVectorMake(0, mJumpY + (s.frame.height * 0.075)))
    }
  }
  
  // Handles falling animation
  
  func endJumping() {
    let s = self.mSprite
    let y = s.position.y
    
    if y >= mBaseY + mJumpY {
      s.runAction(mJumpDownAni)
    }
  }
  
  func endJumpTimer() {
    self.mSprite.removeActionForKey(Player.kJumpTimer)
    beginJumping()
  }
  
  // Checks if the player is off the screen
  
  func isDead(frame: CGRect, width w: CGFloat) -> Bool {
    let s = self.mSprite
    let x = s.getMaxX()
    let y = s.getMidY()
    
    return x <= frame.origin.x - w || y <= 0
  }
  
  // Creates the jump timer action
  
  private func createJumpTimerAction() -> SKAction {
    let wt: CGFloat = 0.2
    let w = SKAction.waitForDuration(0.01)
    let t = SKAction.runBlock({
      if self.mTime < Physics.kMaxJumpTime {
        self.mTime += wt
      } else {
        self.endJumpTimer()
      }
      
      print(self.mTime)
    })
    
    return SKAction.repeatActionForever(SKAction.sequence([t, w]))
  }
  
  func movePlayer(distance: CGFloat) {
    let s = self.mSprite
    s.position.x += distance
    
    if let w = mWings {
      w.position.x = s.position.x
      w.position.y = s.position.y + s.halfHeight() / 3
    }
  }
  
  // Handle removing wings
  
  func removeWings() {
    if let s = self.mSprite.scene {
      s.physicsWorld.gravity.dy = -Physics.kGravity
    }
    
    if let w = mWings {
      w.removeFromParent()
      mWings = nil
    }
  }
  
  func addWings(wing: SKSpriteNode?) {
    let s = self.mSprite
    
    if mWings == nil && wing != nil {
      mWings = wing
      mWings?.physicsBody = nil
      mOldSize.wing = mWings?.size
      mWings?.position = CGPointMake(s.position.x + s.halfWidth(),
                                     s.position.y + s.halfHeight() / 3)
      if let sc = s.scene {
        sc.physicsWorld.gravity.dy *= 0.6
        sc.runAction(Wings.kWingTimer)
      }
    }
  }
  
  // Handle reappearing after teleport
  
  func reappear() {
    let s = self.mSprite
    
    s.size = mOldSize.player
    s.physicsBody?.dynamic = true
    mTeleportPos = 0
    mTeleporting = false
    
    if let w = mWings, let ws = mOldSize.wing {
      w.size = ws
    }
  }
  
  // Handle teleporting
  
  func teleport() {
    let s = self.mSprite
    let zs = CGSizeMake(0, 0)
    
    s.size = zs
    mWings?.size = zs
    s.physicsBody?.dynamic = false
    mTeleportPos = mSprite.position.x + 1500
    mJumping = false
    mTeleporting = true
  }
  
  
  override func createNode() {
    let s = self.mSprite
    
    s.removeAllActions()
    s.scale(0.075)
    s.anchorPointX(0)
    s.position = CGPointMake(30, 500)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: s.size)
    s.physicsBody?.categoryBitMask = Collision.kPerson
    s.physicsBody?.collisionBitMask = Collision.kPlatform
    s.physicsBody?.contactTestBitMask = Collision.kOrb
    s.physicsBody?.allowsRotation = false
    s.physicsBody?.velocity.dx = 1.2
    s.name = Player.kName
    s.zPosition = Spacing.kPersonZIndex
    
    mWings = nil
    Physics.kInstance.mVelocityY = 200 * s.physicsBody!.mass
  }
}