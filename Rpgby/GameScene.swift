//
//  GameScene.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright (c) 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class GameScene: BaseScene, SKPhysicsContactDelegate, Manager, Reset,
PauseDelegate {
  var mCountDown = false
  var mBegin = false
  var mGameOver = false
  var mBackgrounds = [SKSpriteNode]()
  var mPlatforms = [Platform]()
  var mPreviousPlatform = 0
  var mPreviousSprite: SKSpriteNode!
  var mPreviousTime: CFTimeInterval?
  let mCamera = SKCameraNode()
  
  // Handle jumping
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    let pl = Player.kInstance
    let hud = HudUi.kInstance.mSprite
    
    if !mCountDown {
      mCountDown = true
      
      if let sl = HudUi.kHUDs[StartLabel.kIndex] as? StartLabel {
        hud.addChild(sl)
        sl.position = self.getCenterPoint()
        hud.runAction(StartLabel.kCountAct, completion: begin)
      }
    } else if mBegin {
      pl.startJumpTimer()
    } else if mGameOver {
      self.removeAllChildren()
      self.removeAllActions()
      HudUi.kInstance.mSprite.removeAllChildren()
      Physics.kInstance.fInit()
      self.mPlatforms.removeAll()
      self.mBackgrounds.removeAll()
      self.mBegin = false
      self.mCountDown = false 
      self.mGameOver = false
      self.mPreviousTime = nil
      self.fInit()
      
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let p = Player.kInstance
    
    if mBegin && p.mJumping {
      p.endJumpTimer()
    }
  }
  
  // Handle platform generation
  
  override func didSimulatePhysics() {
    if mPlatforms.count > 0 {
      let pz = mPlatforms[0]
      
      if mPreviousSprite.isPast(self.mCamera.frame) && mPlatforms.count < 10 {
        self.createPlatform()
      }
      
      if pz.mSprite.isPast(self.mCamera.frame) {
        pz.mSprite.removeFromParent()
        self.mPlatforms.removeFirst()
      }
    }
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    let p = Player.kInstance
    let hud = HudUi.kInstance.mSprite
    let ml = HudUi.kHUDs[MeterLabel.kIndex] as! MeterLabel
    let phy = Physics.kInstance
    
    if p.mJumping {
      p.endJumping()
    }
    
    if mBegin {
      if !self.paused {
        let x =  phy.mRunSpeed * CGFloat(currentTime - (mPreviousTime ?? currentTime))
        p.mSprite.position.x += x
        hud.position.x += x
        mCamera.position.x += x
        ml.mDistance += Int(x)
        ml.handleText()
        phy.mVelocityX = x
      }
      
      mPreviousTime = currentTime
      
      if p.isDead(hud.frame) {
        end()
        return
      }
      
      let adv: CGFloat = 400
      let cx = mCamera.position.x
      
      if mBackgrounds.count > 0 {
        let bg = mBackgrounds[0]
        let bg2 = mBackgrounds[1]
        
        
        if bg.getMaxX() + adv <=  cx {
          bg.position = setBackgroundPosition(bg2, bg2: bg, adv: adv)
        }
        
        if bg2.getMaxX() + adv <= cx {
          bg2.position = setBackgroundPosition(bg, bg2: bg2, adv: adv)
        }
      }
    }
  }
  
  func didBeginContact(contact: SKPhysicsContact) {
    var a = contact.bodyA.categoryBitMask
    var b = contact.bodyB.categoryBitMask
    (a, b) = a < b ? (a, b) : (b, a)
    
    switch (a, b) {
    case (Collision.kPlatform, Collision.kPerson): // handle landing
      let p = Player.kInstance
      p.mJumping = false
      
      if mBegin {
        p.beginRunning()
      }
    case (Collision.kPerson, Collision.kOrb): // handle running into orb
      self.runAction(Orb.kCollectSfx)
      OrbCount.kInstance.handleText()
      contact.bodyB.node?.removeFromParent()
    default:
      break
    }
  }
  
  func begin() {
    let pl = Player.kInstance
    let phy = Physics.kInstance
    let w = SKAction.waitForDuration(1)
    let rb = SKAction.runBlock({
      
      if phy.mRunSpeed < Physics.kMaxRunSpeed {
        phy.mRunSpeed *= 1.2
      } else {
        self.removeActionForKey(Player.kTimer)
      }
    })
    
    self.mBegin = true
    pl.beginRunning()
    self.runAction(SKAction.repeatActionForever(SKAction.sequence([w,
      rb])), withKey: Player.kTimer)
  }
  
  func end() {
    let el = HudUi.kHUDs[EndLabel.kIndex] as! SKLabelNode
    
    self.runAction(Player.kFallSfx)
    
    el.position = self.getCenterPoint()
    el.text = OrbCount.kInstance.mCount >= OrbCount.kNeeded ? "Winner Winner!" :
    "Try Again."
    HudUi.kInstance.mSprite.addChild(el)
    
    Player.kInstance.mSprite.removeFromParent()
    self.mBegin = false
    self.mGameOver = true
  }
  
  func isScenePaused() -> Bool {
    return self.paused
  }
  
  func pause() {
    self.paused = true
  }
  
  func resume() {
    self.mPreviousTime = nil
    self.paused = false
  }
  
  // Set up background
  
  override func setUpBackground() {
    super.setUpBackground()
    let bg = self.childNodeWithName(BaseScene.kBackground) as! SKSpriteNode
    bg.position = mCamera.position
    
    let bg2 = bg.copy() as! SKSpriteNode
    bg2.name = BaseScene.kBackground + "2"
    bg2.position = setBackgroundPosition(bg, bg2: bg2, adv: 100)
    
    mBackgrounds.append(bg)
    mBackgrounds.append(bg2)
    
    bg.removeFromParent()
    bg2.removeFromParent()
    
    self.addChild(bg)
    self.addChild(bg2)
  }
  
  // Set up main platform and player
  
  private func setUpPlayer() {
    let g = Platform.kAllPlatforms[0]
    let p = Player.kInstance
    
    g.setPosition(-1, size: self.size)
    p.createNode()
    
    mPlatforms.append(g)
    
    p.mSprite.removeFromParent()
    
    self.addChild(p.mSprite)
    self.addChild(mPlatforms.lastSprite())
    self.camera?.position.x = p.mSprite.position.x
  }
  
  // Sets up the orb
  
  private func setUpOre() {
    let o = Orb.kInstance
    
    o.createNode()
    o.setPosition(mPlatforms[0].mSprite)
    
    self.addChild(o.mSprite.copy() as! SKSpriteNode)
  }
  
  // Handles infinite background position
  
  private func setBackgroundPosition(bg: SKSpriteNode, bg2: SKSpriteNode, adv:
    CGFloat) -> CGPoint {
      return CGPointMake(bg.getMaxX() + adv, bg2.position.y)
  }
  
  // Selects the next platform, randomly
  
  private func createPlatform() {
    let n = Platform.nextPlatform(mPreviousPlatform)
    let p: Platform = n.1
    let o = Orb.kInstance
    
    mPreviousPlatform = n.0
    mPreviousSprite = mPlatforms.lastSprite()
    p.setPosition(mPreviousSprite.getMaxX(), size: self.size)
    mPlatforms.append(p)
    self.addChild(mPlatforms.lastSprite())
    
    if drand48() <= Orb.kProbablity {
      o.setPosition(p.mSprite)
      self.addChild(o.mSprite.copy() as! SKSpriteNode)
    }
  }
  
  private func setUpHUD() {
    let h = HudUi.kInstance
    let hud = h.mSprite
    let kHUDs = HudUi.kHUDs
    h.fInit()
    hud.addChild(kHUDs[MeterLabel.kIndex])
    hud.addChild(kHUDs[Pause.kIndex])
    hud.addChild(kHUDs[OrbCount.kIndex])
    self.addChild(hud)
  }
  
  // Single init func to be called from multiple init
  
  override func fInit() {
    self.view?.ignoresSiblingOrder = true
    self.physicsWorld.gravity = CGVectorMake(0, -Physics.kGravity)
    self.physicsWorld.contactDelegate = self
    self.userInteractionEnabled = true
//    self.shouldEnableEffects = true
    self.camera = mCamera
    self.camera?.center(self.size)
    setUpBackground()
    setUpPlayer()
    setUpOre()
    setUpHUD()
    self.camera?.position.x = UIScreen.scaleWidth(0.5)
    self.camera?.frame.size
    
    for _ in 0...9 {
      createPlatform()
    }
  }
}
