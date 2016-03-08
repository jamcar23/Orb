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

class BaseSprite: Sprite {
  let mSprite: SKSpriteNode!
  
  init(imageName: String) {
    self.mSprite = SKSpriteNode(imageNamed: imageName)
  }
  
  func createSprite() {
    return
  }
}