//
//  SKSpriteNodeExtension.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation
import SpriteKit

// Helper funcs extensions for SKNode and SKSpriteNode

extension SKNode {
  func center(size: CGSize) {
    self.position = CGPointMake(size.width / 2, size.height / 2)
  }
  
  func scale(amount: CGFloat) {
    self.xScale = amount
    self.yScale = amount
  }
  
  func bottom(size: CGSize) {
    self.position = CGPointMake(self.position.x, size.height / 2)
  }
}

extension SKSpriteNode {
  func bottom() {
    self.position.y = halfHeight()
  }
  
  func halfHeight() -> CGFloat {
    return self.size.height / 2
  }
  
  func anchorPointX(x: CGFloat) {
    self.anchorPoint.x = x
  }
}