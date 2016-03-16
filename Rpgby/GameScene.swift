//
//  GameScene.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright (c) 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class GameScene: SKScene, SKPhysicsContactDelegate, Manager, Reset {
  static let kBackground = "Background_cloud"
  var mCountDown = false
  var mBegin = false
  var mGameOver = false
  var mBackgrounds = [SKSpriteNode]()
  var mPlatforms = [Platform]()
  var mPreviousPlatform = 0
  var mPreviousSprite: SKSpriteNode!
  let mCamera = SKCameraNode()
  
  override init(size: CGSize) {
    super.init(size: size)
    self.size = size
    
    fInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fInit()
  }
  
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
      self.mPlatforms.removeAll()
      self.mBackgrounds.removeAll()
      self.mBegin = false
      self.mCountDown = false 
      self.mPreviousSprite = nil
      self.mGameOver = false
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
    
    if p.mJumping {
      p.endJumping()
    }
    
    if mBegin {
      p.mSprite.position.x += p.mMovement
      hud.position.x += p.mMovement
      ml.mDistance += Int(p.mMovement)
      ml.handleText()
      
      if let cam = self.camera {
        cam.position.x += p.mMovement
      }
      
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
      contact.bodyB.node?.removeFromParent()
    default:
      break
    }
  }
  
  func begin() {
    let pl = Player.kInstance
    let w = SKAction.waitForDuration(1)
    let rb = SKAction.runBlock({
      
      if self.mGameOver {
        pl.mVelocity = 0
      }
      
      if pl.mVelocity > 1.0 {
        pl.mMovement *= pl.mVelocity
        pl.mVelocity -= pl.mVelocity * 0.005
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
    let el = HudUi.kHUDs[EndLabel.kIndex]
    
    self.runAction(Player.kFallSfx)
    
    el.position = self.getCenterPoint()
    HudUi.kInstance.mSprite.addChild(el)
    
    Player.kInstance.mSprite.removeFromParent()
    self.mBegin = false
    self.mGameOver = true
  }
  
  // Set up background
  
  private func setUpBackground() {
    let bg = SKSpriteNode(imageNamed: GameScene.kBackground)
    bg.position = mCamera.position
    bg.center(self.size)
    bg.size.height = self.size.height
    bg.name = GameScene.kBackground
    bg.zPosition = Spacing.kBackgroundZIndex
    
    let bg2 = bg.copy() as! SKSpriteNode
    bg2.name = GameScene.kBackground + "2"
    bg2.position = setBackgroundPosition(bg, bg2: bg2, adv: 100)
    
    mBackgrounds.append(bg)
    mBackgrounds.append(bg2)
    
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
    h.fInit()
    hud.addChild(HudUi.kHUDs[MeterLabel.kIndex])
    self.addChild(hud)
  }
  
  // Single init func to be called from multiple init
  
  func fInit() {
    self.view?.ignoresSiblingOrder = true
    self.physicsWorld.gravity = CGVectorMake(0, -Physics.kGravity)
    self.physicsWorld.contactDelegate = self
    self.userInteractionEnabled = true
    self.camera = mCamera
    self.camera?.center(self.size)
    setUpBackground()
    setUpPlayer()
    setUpOre()
    setUpHUD()
    self.camera?.position.x = Player.kInstance.mSprite.position.x * 9.42
    self.camera?.frame.size
    
    for _ in 0...9 {
      createPlatform()
    }
  }
}
