//
//  ArrayExtension.swift
//  Orb
//
//  Created by James Carroll on 3/9/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

extension Array where Element:Platform  {
  func lastSprite() -> SKSpriteNode {
    return self.last!.mSprite.copy() as! SKSpriteNode
  }
  
  func indexPlatform(name: String) -> Int {
    return self.indexOf({($0 as Platform).mName == name}) ?? 0
  }
  
  func findPlatform(name: String) -> Platform {
    return self[indexPlatform(name)]
  }
}