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

final class FluffyPlatform: Platform {
  static let kName = "platform_fluffy1"
  override var mName: String { return FluffyPlatform.kName }
  
  override init() {
    super.init(texture: Platform.kTextures.textureNamed(FluffyPlatform.kName))
  }
  
  override func createNode() {
    let s = self.mSprite
    
    
    s.name = FluffyPlatform.kName
    self.setSharedProperties(CGSizeMake(s.size.width - 80,
      s.size.height - 200))
  }
}