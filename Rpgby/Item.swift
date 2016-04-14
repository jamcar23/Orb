//
//  Item.swift
//  Orb
//
//  Created by James Carroll on 4/14/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

class Item: BaseSprite {
  static let kItems = Item.setUpItems()
  
  func setSharedProperties() {
    let s = self.mSprite
    
    s.physicsBody?.collisionBitMask = Collision.kPlatform
    s.physicsBody?.contactTestBitMask = Collision.kPerson
    s.physicsBody?.restitution = 0.2
    s.zPosition = Spacing.kItemZIndex
  }
  
  func setPosition(platform: SKSpriteNode) {
    let s = self.mSprite
    let x = platform.position.x
    let r = Physics.kInstance.calcRandom(platform.getMaxX(),
                                         lower: x, min: 0)
    
    s.position = CGPointMake(r - s.halfWidth(), platform.getMaxY())
  }
  
  private static func setUpItems() -> [Item] {
    var items = [Item]()
    
    items.insert(Orb.kInstance, atIndex: Orb.kIndex)
    items.insert(Teleport.kInstance, atIndex: Teleport.kIndex)
    items.insert(Wings.kInstance, atIndex: Wings.kIndex)
    
    for i in items {
      i.createNode()
    }
    
    return items
  }
}