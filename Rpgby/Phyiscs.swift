//
//  Phyiscs.swift
//  Orb
//
//  Created by James Carroll on 3/14/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import SpriteKit

final class Physics {
  static let kInstance = Physics()
  static let kGravity: CGFloat = 4.2
  static let kMaxJumpTime: CGFloat = 3.5 // seconds
  
  var mVelocityY: CGFloat!
  
  private init() {
    
  }
  
  // Set a random elevation between the screen height and the point where
  // the sprite touches the bottom
  // TODO tweak y
  
  func randomElevation(sprite s: SKSpriteNode, height h: CGFloat,
    bottom b: Bool, time: CGFloat?) {
      let t = calcTime(time)
      
      if b {
        s.position.y = calcRandom(s.halfHeight(), lower: 5, min: 5)
        return
      }
      
      let max = calcYDistance(45, time: t)
      s.position.y = calcRandom(max - Player.kInstance.mSprite.size
        .height, lower: 0, min: s.halfHeight())
  }
  
  // Set a random distance to jump within a certain margin
  // TODO tweak x
  
  func randomDistance(sprite s: SKSpriteNode, previous: CGFloat, width: CGFloat,
    time: CGFloat?) {
      let p = Player.kInstance
      let t = calcTime(time)
      let max = calcXDistance(45, time: t) // distance of jump
      let min = calcXDistance(0, time: 0.25) // distance of fall
      let x = calcRandom(max, lower: min, min: p.mSprite.size.width)
      let w = width * CGFloat(drand48())
      var px = min
      
      if x < width / 2 {
        px = x
      } else {
        px = calcRandom(width * 0.75, lower: w, min: width / 3 - w)
        
        if px > max {
          px = max - 25
        }
      }
      
      s.position.x = px + previous
  }
  
  // Calculates x position based on angle and time
  
  func calcXDistance(angle: CGFloat, time: CGFloat) -> CGFloat {
    return (Player.kInstance.mMovement ^^ time) * cos(angle)
  }
  
  // Calculates max jump height based on angle and time
  
  func calcYDistance(angle: CGFloat, time: CGFloat) -> CGFloat {
    return ((mVelocityY ^^ 2) * (sin(angle) ^^ 2)) / (2 * Physics.kGravity)
  }
  
  // Checks if time is not nil and less than max time 
  
  func calcTime(time: CGFloat?) -> CGFloat {
    return time != nil && time! < Physics.kMaxJumpTime ? time! : Physics.kMaxJumpTime
  }
  
  // Calcs a random number between upper and lower plus the minimum
  
  func calcRandom(upper: CGFloat, lower: CGFloat, min m: CGFloat) -> CGFloat {
    let f: (CGFloat, CGFloat) = (fabs(upper), fabs(lower))
    let ul = f.0 >= f.1 ? (f.0, f.1) : (f.1, f.0)
    
    return CGFloat(arc4random_uniform(UInt32(ul.0 - ul.1))) + ul.1 + m
  }
}