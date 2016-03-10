//
//  GameScene.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright (c) 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
  static let kBackground = "Background"
  var mBegin = false
  var mBackgrounds = [SKSpriteNode]()
  var mPlatforms = [Platform]()
  var mPreviousPlatform = 0
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
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    view.showsFPS = true
    view.showsNodeCount = true
  }
  
  // Handle jumping
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    let pl = Player.kInstance
    
    if !mBegin {
      mBegin = true
      pl.beginRunning()
    } else {
      pl.beginJumping()
    }
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    let p = Player.kInstance
    
    if p.mJumping {
      p.endJumping()
    }
    
    if mBegin {
      p.mSprite.position.x += Player.kMovement
      
      if p.mSprite.isPast(self.frame) {
        p.mSprite.removeFromParent()
        return
      }
      
      if let cam = self.camera {
        cam.position.x += Player.kMovement
      }
      
      let adv: CGFloat = 400
      let cx = mCamera.position.x
      let bg = mBackgrounds[0]
      let bg2 = mBackgrounds[1]
      
      if mPlatforms.count > 0 {
        let pz = mPlatforms[0]
        
        if pz.mSprite.isPast(self.mCamera.frame) {
          self.mPlatforms.removeFirst()
        }
        
        if mPlatforms.lastSprite().isPast(self.mCamera.frame) {
          self.createPlatform()
        }
      }
      
      if bg.getMaxX() + adv <=  cx {
        bg.position = setBackgroundPosition(bg2, bg2: bg, adv: adv)
      }
      
      if bg2.getMaxX() + adv <= cx {
        bg2.position = setBackgroundPosition(bg, bg2: bg2, adv: adv)
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
      self.childNodeWithName(Orb.kName)?.removeFromParent()
    default:
      break
    }
  }
  
  // Set up background
  
  private func setUpBackground() {
    let bg = SKSpriteNode(imageNamed: GameScene.kBackground)
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
    
    g.setPosition(-1)
    p.createSprite()
    
    mPlatforms.append(g)
    
    self.addChild(p.mSprite)
    self.addChild(mPlatforms.lastSprite())
    self.camera?.position.x = p.mSprite.position.x
  }
  
  // Sets up the orb
  
  private func setUpOre() {
    let o = Orb(imageName: Orb.kRed)
    
    o.createSprite()
    o.setPosition(mPlatforms.findPlatform(MainPlatform.kName).getMaxX())
    
    self.addChild(o.mSprite)
  }
  
  // Handles infinite background position
  
  private func setBackgroundPosition(bg: SKSpriteNode, bg2: SKSpriteNode, adv:
    CGFloat) -> CGPoint {
      return CGPointMake(bg.getMaxX() + adv, bg2.position.y)
  }
  
  // Selects the next platform, randomly
  
  func createPlatform() {
    let n = Platform.nextPlatform(mPreviousPlatform)
    let p: Platform = n.1
    
    mPreviousPlatform = n.0
    p.setPosition(mPlatforms.lastSprite().getMaxX())
    mPlatforms.append(p)
    self.addChild(mPlatforms.lastSprite())
    
  }
  
  // Single init func to be called from multiple init
  
  private func fInit() {
    self.physicsWorld.gravity = CGVectorMake(0, -4.2)
    self.physicsWorld.contactDelegate = self
    self.userInteractionEnabled = true
    self.camera = mCamera
    self.camera?.center(self.size)
    setUpBackground()
    setUpPlayer()
    setUpOre()
    self.camera?.position.x = Player.kInstance.mSprite.position.x * 9.42
    
    for _ in 0..<3 {
      createPlatform()
    }
  }
}
