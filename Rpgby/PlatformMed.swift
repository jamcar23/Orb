//
//  MedPlatform.swift
//  Orb
//
//  Created by James Carroll on 3/12/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class MedPlatform: Platform {
  static let kName = "platform_med"
  override var mName: String { return MedPlatform.kName }
  
  override init() {
    super.init(texture: Platform.kTextures.textureNamed(MedPlatform.kName))
    self.mBottom = false
  }
  
  override func createNode() {
    let s = self.mSprite
    
    s.name = MedPlatform.kName
    self.setSharedProperties(CGSizeMake(s.size.width - 95, s.size.height - 75))
  }
}
