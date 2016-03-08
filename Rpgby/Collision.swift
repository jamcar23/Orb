//
//  Collision.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation

// Class for collision categories

class Collision {
  static let kPlatform: UInt32 = 0x1 << 0
  static let kPerson: UInt32 = 0x1 << 1
  static let kOrb: UInt32 = 0x1 << 2
}