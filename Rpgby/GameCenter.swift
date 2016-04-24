//
//  GameCenter.swift
//  Orb
//
//  Created by James Carroll on 4/21/16.
//  Copyright © 2016 James Carroll. All rights reserved.
//

import GameKit

final class GameCenter: NSObject, GKGameCenterControllerDelegate {
  static let kInstance = GameCenter()
  let kPlayer = GKLocalPlayer.localPlayer()
  
  var mDelegate: GameCenterDelegate!
  
  private override init() {
    super.init()
  }
  
  func authenticate() {
    kPlayer.authenticateHandler = { (vc: UIViewController?, e: NSError?) in
      if let v = vc {
        self.mDelegate.showViewController(v)
      }
      
      if let e = e {
        print(e.description)
      }
    }
  }
  
  func isAuthenticated() -> Bool {
    return kPlayer.authenticated
  }
  
  func showGameCenter() {
    if let sgc = mDelegate.showGameCenter {
      sgc()
    }
  }
  
  func postScores() {
    let oc = OrbCount.kInstance.mNeed
    let dm = MeterLabel.kInstance.mDistance
    let ob = GKScore(leaderboardIdentifier: kPackgeName + ".orbscollected", player: kPlayer)
    let db = GKScore(leaderboardIdentifier: kPackgeName + ".distanceran", player: kPlayer)
    
    ob.value = Int64(oc)
    db.value = Int64(dm)
    
    GKScore.reportScores([ob, db], withCompletionHandler: { err in
      if let e = err {
        print(e.description)
      }
    })
  }
  
  @objc func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
  }
}

@objc protocol GameCenterDelegate {
  func showViewController(viewController: UIViewController)
  optional func showGameCenter()
}

extension UIViewController: GameCenterDelegate {
  func showViewController(viewController: UIViewController) {
    self.presentViewController(viewController, animated: true, completion: nil)
  }
}