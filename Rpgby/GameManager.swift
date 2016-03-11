//
//  GameManager.swift
//  Orb
//
//  Created by James Carroll on 3/8/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit

// Common methods for objects to call when the game begins and ends 

protocol Manager {
  func begin()
  func end()
}