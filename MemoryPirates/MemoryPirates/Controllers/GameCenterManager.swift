//
//  GameCenterManager.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/21/23.
//

import UIKit
import GameKit


class GameCenterManager: NSObject, GKGameCenterControllerDelegate {
    
    let presentationController: UIViewController = ViewController()
    
    override init() {
        super.init()
        gameCenterAceesPoint.isActive = true
    }
    
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { [weak self] viewController, error in
            if let viewController = viewController {
                self?.presentationController.present(viewController, animated: true)
            } else if localPlayer.isAuthenticated {
                NSLog("Player successfully authenticated")
            } else if let error = error {
                NSLog("Game Center authentication error: \(error)")
            }
        }
    }
    
    // Configure shared access point for game center
    var gameCenterAceesPoint: GKAccessPoint {
        GKAccessPoint.shared.location = .topLeading
        return GKAccessPoint.shared
    }
    
    func showLeaderboard() {
        // Display scores for a specific leaderboard.
        let viewController = GKGameCenterViewController(
                        leaderboardID: "triplemonkeystudio.memorypiratesfastesttimes",
                        playerScope: .global,
                        timeScope: .allTime)
        viewController.gameCenterDelegate = self
        self.presentationController.present(viewController, animated: true, completion: nil)
    }
    
    // Add score to leaderboard
    func reportScore(score: Int) {
        
    }
    
    // Dismiss view controller when finished
    @objc func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

