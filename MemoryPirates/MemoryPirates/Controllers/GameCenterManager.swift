//
//  GameCenterManager.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/21/23.
//

import UIKit
import GameKit


class GameCenterManager: NSObject {
    
    let presentationController: UIViewController = ViewController()
    static let sharedManager = GameCenterManager()
    private override init() {}
    
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
    
    func showLeaderboard() {
        
    }
    
    func reportScore(score: Int) {
        
    }
    
    @objc func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
