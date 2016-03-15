//
//  Phyiscs.swift
//  Orb
//
//  Created by James Carroll on 3/14/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

class Physics {
  static let kInstance = Physics()
  static let kGravity: CGFloat = 4.2
  static let kMaxJumpTime: CGFloat = 0.5 // seconds
  
  private init() {
    
  }
  
  // Set a random elevation between the screen height and the point where
  // the sprite touches the bottom
  // TODO tweak y
  
  func randomElevation(sprite s: SKSpriteNode, height h: CGFloat,
    bottom b: Bool, time: CGFloat?) {
      let t = calcTime(time)
      
      if b {
        s.position.y = calcRandom(upper: s.halfHeight(), lower: 0, min: 5)
        return
      }
      
      let max = calcYDistance(45, time: t)
      s.position.y = calcRandom(upper: max - Player.kInstance.mSprite.size
        .height, lower: 0, min: s.getMaxY())
  }
  
  // Set a random distance to jump within a certain margin
  // TODO tweak x
  
  func randomDistance(sprite s: SKSpriteNode, previous: CGFloat, width: CGFloat,
    time: CGFloat?) {
      let p = Player.kInstance
      let t = calcTime(time)
      let max = calcXDistance(45, time: t) // distance of jump
      let min = calcXDistance(0, time: 0.25) // distance of fall
      let x = calcRandom(upper: max, lower: min, min: p.mSprite.size.width)
      let w = width * CGFloat(drand48())
      var px = min
      
      if x < width {
        px = x
      } else {
        px = calcRandom(upper: width + w, lower: 0, min: width - w)
        
        if px > max {
          px = max - 25
        }
      }
      
      s.position.x = px + previous
  }
  
  // Calculates x position based on angle and time
  
  private func calcXDistance(angle: CGFloat, time: CGFloat) -> CGFloat {
    return (Player.kInstance.mMovement ^^ time) * cos(angle)
  }
  
  private func calcYDistance(angle: CGFloat, time: CGFloat) -> CGFloat {
    return ((Player.kInstance.mJumpY ^^ time) * sin(angle)) - (0.5 * (
      Physics.kGravity * (time ^^ 2)))
  }
  
  private func calcTime(time: CGFloat?) -> CGFloat {
    return time != nil && time! < Physics.kMaxJumpTime ? time! : Physics.kMaxJumpTime
  }
  
  // Calcs a random number between upper and lower plus the minimum
  
  private func calcRandom(upper u: CGFloat, lower l: CGFloat, min m: CGFloat) -> CGFloat {
    return CGFloat(arc4random_uniform(UInt32(fabs(u) - fabs(l)))) + l + m
  }
}