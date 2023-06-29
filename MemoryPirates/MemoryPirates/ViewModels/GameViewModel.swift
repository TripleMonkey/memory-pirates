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
    
    // Singlton pattern to maintain single game vm instance
    static let shared = GameViewModel()
    private init() {
        prepareNewGame()
    }
    
    @Published var currentGame: Playthrough?
    // Timer instance
    @Published var elapsedTimer: Timer?
    // Count Matches
    @Published var matchCount: Int = 0
    // Count game moves
    @Published var moves: Int = 0
    // Bool for play button visibility
    @Published var playButtonIsActive: Bool = false
    // String to hold current game elapsed time
    @Published var currentElapsedTimeLabel = "0"
    // Set opacity of cards based on game state
    @Published var cardOpacity: Double = 1.0
    
    // Context
    var managedObjectContext = AppDelegate.sharedContext
    
    // Array to hold tapped cards
    var currentMove = [Card]()
    
    // MARK: Start Game
    // Reset or setup new game
    func prepareNewGame() {
        // Reset game values
        currentGame = nil
        elapsedTimer?.invalidate()
        matchCount = 0
        moves = 0
        currentMove.removeAll()
        // Create new playthrough
        currentGame = Playthrough(cards: assignValues(cardCount: 30))
        // Show Play button
        playButtonIsActive = true
    }
    
    // Function to start new game
    func startGame() {
        guard let game = currentGame else { return }
        // Hide play button
        playButtonIsActive = false
        // Show cards
        showCardValues()
        // Set timer to hide cards after 5 seconds
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideCardValues), userInfo: nil, repeats: false)
        playAudio(sound: "countDownSound", type: ".mp3")
        // Wait 5 seconds then set playthrough start time after timer stops
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setStartTime), userInfo: nil, repeats: false)
        if game.startTime != nil {
            // Start elapsed time counter
            self.elapsedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        }
    }
    
    // Function to toggle play button and game state
    @objc func toggleGameState() {
        // Toggle play button
        playButtonIsActive.toggle()
        // Set card opacity
        if playButtonIsActive {
            cardOpacity = 0.5
        }
        else {
            cardOpacity = 0.5
        }
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
    
    // MARK: Game Play
    
    // Clear matches
    func clearMatches() {
        guard let game = currentGame else { return }
        for i in 0..<game.cards.count {
            currentGame!.cards[i].position = .faceDown
        }
    }
    
    // Function to show all cards
    @objc func showCardValues() {
        guard let game = currentGame else { return }
        for i in 0..<game.cards.count {
            // Show card value
            game.cards[i].position = .faceUp
        }
    }
    
    // Function to show all cards
    @objc func hideCardValues() {
        guard let game = currentGame else { return }
        for i in 0..<game.cards.count {
            // Hide card value
            game.cards[i].position = .faceDown
        }
    }

    // Check for successful match
    private func matchCheck() {
        guard currentMove.count == 2 else { return }
        if currentMove[0].value == currentMove[1].value {
            playAudio(sound: "matchSound", type: ".mp3")
            self.matchCount += 1
            print(matchCount)
            // Set both cards to matched position
            currentMove[0].position = .matched
            currentMove[1].position = .matched
        } else {
            playAudio(sound: "noMatchSound", type: ".mp3")
            // Return both cards to face down position
            currentMove[0].position = .faceDown
            currentMove[1].position = .faceDown
        }
        // Clear Match array
        currentMove.removeAll()
    }
    
    // Func to record card taps
    func checkCard(card: Card) {
        card.position = .faceUp
        switch self.currentMove.count {
        case 0:
            currentMove.append(card)
        case 1:
            currentMove.append(card)
        default:
            print("More than 2 cards in match array. How could you let it come to this?")
            currentMove.removeAll()
        }
        if currentMove.count == 2 {
            matchCheck()
        }
        print("Card count: \(currentMove.count)")
    }

    // Function to diplay elapsed time
    @objc func updateElapsedTime() {
        // Create formatter to convert double to formatted string
        let componentFormatter = DateComponentsFormatter()
        componentFormatter.includesApproximationPhrase = false
        componentFormatter.allowedUnits = [.hour, .minute, .second]
        componentFormatter.unitsStyle = .positional
        componentFormatter.zeroFormattingBehavior = .pad
        // Set current time label with formatted elapsed time
        guard let game = currentGame else { return }
        currentElapsedTimeLabel = componentFormatter.string(from: game.startTime?.timeIntervalSinceNow ?? 0) ?? "0"
    }

    // Function to set start time
    @objc func setStartTime() {
        guard let game = currentGame else { return }
        game.startTime = Date()
    }

    // MARK: End Game
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
