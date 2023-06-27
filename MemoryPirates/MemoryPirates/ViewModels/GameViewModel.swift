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
    
    //Function to assign random values to game cards
    func assignValues(cardCount: Int) -> [Card] {
        // Array for card value string names
        var stringValues: [String] = []
        // Get array on ints for card values
        var ints = createIntArray(withCountOf: cardCount/2)
        // Add duplicate values to array
        ints.append(contentsOf: ints)
        // Shuffle values
        let shuffledValues = ints.shuffled()
        // Add to string values formatted to match asset title
        for i in 0..<shuffledValues.count {
            stringValues.append("cardFace\(shuffledValues[i])")
        }
        // Retrun array as cards with string values
        return cards(from: stringValues)
    }
    // Return random ints array of specified length
    func createIntArray(withCountOf count: Int) -> [Int] {
        // Arrays to hold random Int
        var intArray = [Int]()
        // Random Int value
        var randomInt = Int()
        // Var for duplicate check
        var matchingInts = [Int]()
        
        while intArray.count < count {
            // Get random int value
            randomInt = Int.random(in: 1...143)
            // Filter for matches to randomInt in array of Ints
            matchingInts = intArray.filter({ (int) -> Bool in
                return int == randomInt
            })
            if matchingInts.count == 0 {
                // Assign random int to array
                intArray.append(randomInt)
            }
        }
        return intArray
    }
    // Convert array of strings to array of Cards
    func cards(from strings: [String]) -> [Card]{
        var cards: [Card] = []
        for i in 0..<strings.count {
            cards.append(Card(imageString: strings[i]))
        }
        return cards
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
}
