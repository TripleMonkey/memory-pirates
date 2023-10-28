//
//  GameCenterManager.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/21/23.
//

import GameKit


class GameCenterManager: NSObject, GKGameCenterControllerDelegate {
    
    let presentationController = UIViewController()
    
    // Show game center login or welcome view
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
    var accessPoint: GKAccessPoint {
        GKAccessPoint.shared.location = .topTrailing
        GKAccessPoint.shared.isActive = false
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
    func reportScore(chests: Int, timeInMilliseconds: Int) {
        // Add score to fewestChest leaderboard
        GKLeaderboard.submitScore(chests, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.triplemonkeystudio.MemeryPirates.FewestMoves"]) { error in
            guard let err = error else {
                print("New score saved")
                return
            }
            print("Error reporting score: \(err).")
        }
        // Add time to bestTime leaderboard
        GKLeaderboard.submitScore(timeInMilliseconds, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.triplemonkeystudio.MemoryPirates.FastestPlunder"]) { error in
            guard let err = error else {
                print("New time saved")
                return
            }
            print("Error reporting score: \(err).")
        }
    }
    
    // Dismiss view controller when finished
    @objc func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

