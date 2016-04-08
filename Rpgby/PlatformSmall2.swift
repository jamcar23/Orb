//
//  LowPlatform.swift
//  Orb
//
//  Created by James Carroll on 3/12/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class SmallPlatform2: Platform {
  static let kName = "platform_small2"
  override var mName: String { return SmallPlatform2.kName }
  
  override init() {
    super.init(texture: Platform.kTextures.textureNamed(SmallPlatform2.kName))
    self.mBottom = false
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.name = SmallPlatform2.kName
    self.setSharedProperties(CGSizeMake(s.size.width - 50,
      s.size.height - 25))
  }
}
