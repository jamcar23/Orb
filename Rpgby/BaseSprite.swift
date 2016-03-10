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

class BaseSprite: NSObject, Sprite {
  let mSprite: SKSpriteNode!
  var mName: String { return "BaseSprite" }
  
  init(textureName: String) {
    self.mSprite = SKSpriteNode(texture: SKTexture(imageNamed: textureName))
  }
  
  func createSprite() {
    return
  }
}