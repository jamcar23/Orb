//
//  Operators.swift
//  Orb
//
//  Created by James Carroll on 3/11/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import UIKit

// File for custom operators 

// power operations

infix operator ^^ { associativity left precedence 160 }

func ^^ (radix: CGFloat, power: CGFloat) -> CGFloat {
  return CGFloat(pow(Double(radix), Double(power)))
}