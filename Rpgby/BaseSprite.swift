//
//  BaseSprite.swift
//  Rpgby
//
//  Created by James Carroll on 3/2/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit
import SpriteKit

// Base class for all sprites

class BaseSprite: NSObject, Node {
  var mSprite: SKSpriteNode!
  var mName: String { return "BaseSprite" }
  
  override init() {
    self.mSprite = SKSpriteNode()
    
    super.init()
  }
  
  init(texture: SKTexture) {
    self.mSprite = SKSpriteNode(texture: texture)
  }
  
  init(color: UIColor, size: CGSize) {
    self.mSprite = SKSpriteNode(color: color, size: size)
  }
  
  func createNode() {
    return
  }
  
  // MARK: - GetXY
  
  func getMaxX() -> CGFloat {
    return self.mSprite.getMaxX()
  }
  
  func getMaxY() -> CGFloat {
    return self.mSprite.getMaxY()
  }
  
  func getMidX() -> CGFloat {
    return self.mSprite.getMidX()
  }
  
  func getMidY() -> CGFloat {
    return self.mSprite.getMidY()
  }
  
  func getMinX() -> CGFloat {
    return self.mSprite.getMinX()
  }
  
  func getMinY() -> CGFloat {
    return self.mSprite.getMinY()
  }
  
  func getCenterPoint() -> CGPoint {
    return CGPointMake(getMidX(), getMidY())
  }
}