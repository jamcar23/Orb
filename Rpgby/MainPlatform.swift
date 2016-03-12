//
//  MainPlatform.swift
//  Rpgby
//
//  Created by James Carroll on 3/2/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation
import SpriteKit

// Class for the main platform (the one you start on)

final class MainPlatform: Platform {
  static let kName = "mainPlatform"
  override var mName: String { return MainPlatform.kName }
  
  init() {
    super.init(texture: Platform.kTextures.textureNamed(MainPlatform.kName))
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.scale(0.7)
    s.anchorPointX(0)
    s.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(s.size.width, s.size.height - 160), center: self.getCenterPoint())
    s.name = MainPlatform.kName
    self.setSharedProperties()
  }
}