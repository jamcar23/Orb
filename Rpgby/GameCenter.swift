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
  static let kViewController = GKGameCenterViewController()
  static let kAchievements = [
    GKAchievement(identifier: kPackgeName + ".gettingstarted"),
    GKAchievement(identifier: kPackgeName + ".keeprunning"),
    GKAchievement(identifier: kPackgeName + ".bigten"),
    GKAchievement(identifier: kPackgeName + ".died"),
    GKAchievement(identifier: kPackgeName + ".collector")
  ]
  let kPlayer = GKLocalPlayer.localPlayer()
  
  var mDelegate: GameCenterDelegate!
  
  private override init() {
    super.init()
    GameCenter.kViewController.gameCenterDelegate = self
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
        print("Error in postScores: " + e.description)
      }
    })
  }
  
  func updateCollectiveRunAchievement(meters m: Int) {
    updateAchievement(GameCenter.kAchievements[1], percent: (Double(m) / 20000.0))
  }
  
  func updateCollectiveOrb(orbs o: Int) {
    updateAchievement(GameCenter.kAchievements[4], percent: (Double(o) / 1000))
  }
  
  func completeGettingStarted() {
    updateAchievement(GameCenter.kAchievements[0], percent: 1)
  }
  
  func completeBigTen() {
    updateAchievement(GameCenter.kAchievements[2], percent: 1)
  }
  
  func completeDying() {
    updateAchievement(GameCenter.kAchievements[3], percent: 1)
  }
  
  private func updateAchievement(achievement: GKAchievement, percent: Double) {
    if !achievement.completed {
      achievement.showsCompletionBanner = true
      achievement.percentComplete += percent * 100
    }
  }
  
  func postAchievements() {
    let ach = GameCenter.kAchievements.flatMap{ (gak: GKAchievement) in
      return gak.percentComplete > 1.0 ?  gak : nil}
    
    GKAchievement.reportAchievements(ach, withCompletionHandler: { (err: NSError?) in
      if let e = err {
        print("Error in postAchievements: " + e.description)
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