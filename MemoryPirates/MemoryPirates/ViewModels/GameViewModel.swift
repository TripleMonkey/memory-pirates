//
//  GameViewModel.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import Foundation
import UIKit
import CoreData

final class GameViewModel: ObservableObject {
    
    
    @Published var currentGame: Playthrough
    // Timer instance
    @Published var elapsedTimer: Timer?
    // Count Matches
    @Published var matchCount: Int = 0
    // Count game moves
    @Published var moves: Int = 0
    // Context
    var managedObjectContext = AppDelegate.sharedContext
    
    init() {
        currentGame = Playthrough(gameSize: 30)
    }
    
    // MARK: Game play
    
    // Function to end game
    func endGame() {
        // guard currentGame != nil else { return }
        if matchCount == 15 {
            
            // Finalize game values and add new score to core data
            let newScore = NSEntityDescription.insertNewObject(forEntityName: "Score", into: self.managedObjectContext) as! Score
            newScore.totalMoves = Int16(moves)
            newScore.timeStarted = currentGame.startTime
            newScore.playerName = UserDefaults.standard.string(forKey: "name")
            newScore.elapsedTime = currentGame.startTime!.timeIntervalSinceNow
            
            // Add score to game center leaderboard
            // Pass elapsed time multipled by -100 to format for positive value in miliseconds
            GameCenterManager().reportScore(chests: moves, timeInMilliseconds: Int(newScore.elapsedTime*(-100)))
            
            // Stop timer
            elapsedTimer?.invalidate()
            // End game animation and audio
            playAudio(sound: "completeSound", type: ".mp3")
            // Save to CoreData
            do {
                print("We are here")
                try managedObjectContext.save()
            }
            catch {
                print("Error saving score in endGame function.")
            }
        }
        moves = 0
        matchCount = 0
        
        // TODO: Reload table view
        
    }
}
