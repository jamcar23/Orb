//
//  DataManager.swift
//  Orb
//
//  Created by James Carroll on 3/24/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import Foundation

let kPackgeName = "xyz.jamescarroll.orb"

// Helper class to access NSUserDefaults

final class DataManager {
  static let kDefaults = NSUserDefaults()
  static let kInstance = DataManager()
  static let kInstruct = kPackgeName + ".seenInstructions"
  static let kOrbCount = kPackgeName + ".orbCount"
  
  private init() {
    
  }
  
  static func hasSeenInstructions() -> Bool {
    return kDefaults.boolForKey(kInstruct)
  }
  
  static func getMaxOrbsCollected() -> Int {
    return kDefaults.integerForKey(kOrbCount)
  }
  
  static func setMaxOrbsCollected(orbs: Int) {
    kDefaults.setInteger(orbs, forKey: kOrbCount)
  }
}