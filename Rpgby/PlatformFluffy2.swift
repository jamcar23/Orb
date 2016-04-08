//
//  LargePlatform.swift
//  Orb
//
//  Created by James Carroll on 3/8/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class FluffyPlatform2: Platform {
  static let kName = "platform_fluffy2"
  override var mName: String { return FluffyPlatform2.kName }
  
  override init() {
    super.init(texture: Platform.kTextures.textureNamed(FluffyPlatform2.kName))
  }
  
  override func createNode() {
    let s = self.mSprite
    
    
    s.name = FluffyPlatform2.kName
    self.setSharedProperties(CGSizeMake(s.size.width - 80,
      s.size.height - 200))
  }
}
