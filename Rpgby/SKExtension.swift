//
//  SKExtension.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation
import SpriteKit

// Helper funcs extensions for SKNode, SKSpriteNode, and SKTextureAtlas

// MARK : - SKNode

extension SKNode: Node {
  // MARK: - Helper funcs
  
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
  
  func isPast(frame: CGRect) -> Bool {
    let x = self.position.x
    let y = self.position.y
    
    return x <= frame.origin.x || y <= 0
  }
  
  // MARK: - Node
  
  var mName: String { return "SKNode" }
  
  func createNode() {
    return
  }
  
  func getMaxY() -> CGFloat {
    return CGRectGetMaxY(self.frame)
  }
  
  func getMidY() -> CGFloat {
    return CGRectGetMidY(self.frame)
  }
  
  func getMinY() -> CGFloat {
    return CGRectGetMinY(self.frame)
  }
  
  func getMaxX() -> CGFloat {
    return CGRectGetMaxX(self.frame)
  }
  
  func getMidX() -> CGFloat {
    return CGRectGetMidX(self.frame)
  }
  
  func getMinX() -> CGFloat {
    return CGRectGetMinX(self.frame)
  }
  
  func getCenterPoint() -> CGPoint {
    return CGPointMake(getMidX(), getMidY())
  }
}

// MARK: - SKSpriteNode

extension SKSpriteNode {
  // MARK: - Helper funcs
  
  func bottom() {
    self.position.y = halfHeight()
  }
  
  func halfHeight() -> CGFloat {
    return self.size.height / 2
  }
  
  func halfWidth() -> CGFloat {
    return self.size.width / 2
  }
  
  func anchorPointX(x: CGFloat) {
    self.anchorPoint.x = x
  }
}

// MARk: - SKTextureAtlas

extension SKTextureAtlas {
  // MARK: - Helper funcs
  
  func toTextures() -> [SKTexture] {
    var texs = [SKTexture]()
    
    for n in self.textureNames {
      texs.append(SKTexture(imageNamed: n))
    }
    
    return texs
  }
}