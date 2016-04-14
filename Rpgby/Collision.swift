//
//  Collision.swift
//  Rpgby
//
//  Created by James Carroll on 3/1/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation

// Class for collision categories

final class Collision {
  static let kPlatform: UInt32 = 0x1 << 0
  static let kPerson: UInt32 = 0x1 << 1
  static let kOrb: UInt32 = 0x1 << 2
  static let kTeleport: UInt32 = 0x01 << 3
  static let kWing: UInt32 = 0x01 << 4
}