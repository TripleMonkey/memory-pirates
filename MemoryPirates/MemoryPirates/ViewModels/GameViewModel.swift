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
    
    
    @Published var currentGame: Playthrough?
    // Timer instance
    @Published var elapsedTimer: Timer?
    // Count Matches
    @Published var matchCount: Int = 0
    // Count game moves
    @Published var moves: Int = 0
    // Context
    var managedObjectContext = AppDelegate.sharedContext
    
    
    // MARK: Game play
    
    // Function to start new game
    func startGame() {
        // Create new playthrough
        currentGame = Playthrough(cards: assignValues(cardCount: 30))
    }
    
    // Function to end game
    func endGame() {
        if matchCount == 15 {
            guard let game = currentGame, let startTime = game.startTime else { return }
            // Finalize game values and add new score to core data
            let newScore = NSEntityDescription.insertNewObject(forEntityName: "Score", into: self.managedObjectContext) as! Score
            newScore.totalMoves = Int16(moves)
            newScore.timeStarted = startTime
            newScore.playerName = UserDefaults.standard.string(forKey: "name")
            newScore.elapsedTime = game.startTime!.timeIntervalSinceNow
            
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
    
    
    
    //Function to assign random values to game cards
    func assignValues(cardCount: Int) -> [Card] {
        // Arrays to hold image numbers
        var imageNumbers = [Int]()
        // Get random number for face card value
        var randomInt = Int()
        var matchingNumbers = [Int]()
        while imageNumbers.count < cardCount/2 {
            // Get random int value
            randomInt = Int.random(in: 1...143)
            // Filter for matches to randomInt in arrayOfInts
            matchingNumbers = imageNumbers.filter({ (number) -> Bool in
                return number == randomInt
            })
            if matchingNumbers.count == 0 {
                // Assign random int to array
                imageNumbers.append(randomInt)
            }
        }
        // Add image numbers to self
        for int in 0..<imageNumbers.count {
            imageNumbers.append(imageNumbers[int])
        }
        let shuffledNumbers = imageNumbers.shuffled()
        var imageStrings: [String] = []
        for i in 0..<shuffledNumbers.count {
            imageStrings.append("cardFace\(shuffledNumbers[i])")
        }
        return createCards(from: imageStrings)
    }
    
    func createCards(from strings: [String]) -> [Card]{
        var cards: [Card] = []
        for i in 0..<strings.count {
            cards.append(Card(imageString: strings[i]))
        }
        return cards
    }
}
