//
//  SmallPlatform.swift
//  Orb
//
//  Created by James Carroll on 3/12/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class SmallPlatform: Platform {
  static let kName = "platform_small1"
  override var mName: String { return SmallPlatform.kName }
  
  override init() {
    super.init(texture: Platform.kTextures.textureNamed(SmallPlatform.kName))
    self.mBottom = false
  }
  
  override func createNode() {
    let s = self.mSprite
    
    self.setSharedProperties(CGSizeMake(s.size.width - 50,
      s.size.height - 75))
  }
}