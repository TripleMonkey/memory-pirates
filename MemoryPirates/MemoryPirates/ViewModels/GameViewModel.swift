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
    // Array to hold tapped cards
    @Published var cardsTapped = [Card]()
    
    // Context
    var managedObjectContext = AppDelegate.sharedContext
    
    
    // MARK: Start Game
    // Reset or setup new game
    func prepareNewGame() {
        // Reset game values
        currentGame = nil
        matchCount = 0
        moves = 0
        cardsTapped.removeAll()
        // Create new playthrough
        currentGame = Playthrough(cards: assignValues(cardCount: 30))
        // Toggle play button
        playButtonIsActive.toggle()
    }
    
    // Function to start new game
    func startGame() {
        guard let game = currentGame else { return }
        // Toggle play button
        playButtonIsActive.toggle()
        // 5second preview of card values
        //previewAll(cards: game.cards)
        
        playAudio(sound: "countDownSound", type: ".mp3")
//        if game.startTime != nil {
//            // Start elapsed time counter
//            self.elapsedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
//        }
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
    
    // Function to show all cards
    func previewAll(cards: [Card]) {
        for i in 0..<cards.count {
            // Show card value
            cards[i].faceUp.toggle()
            print("Card \(i) is faceUp: \(cards[i].faceUp)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: { [self] in
            for i in 0..<cards.count {
                // Hide card value
                currentGame!.cards[i].faceUp.toggle()
                print("Card \(i) is faceUp: \(cards[i].faceUp)")
            }
            // Initialize game start time
            guard currentGame != nil else { return }
            currentGame!.startTime = Date.now
        })
    }
 
    // Func to record card taps
    func handleCardTap(tappedCard: Card) {
        guard !playButtonIsActive else { return }
        // Add card to list
        if cardsTapped.count < 2 {
            cardsTapped.append(tappedCard)
            tappedCard.faceUp = true
        }
        compareCards()
    }
    
    @objc func compareCards() {
        guard cardsTapped.count == 2 else { return }
        if cardsTapped[0].value == cardsTapped[1].value {
            playAudio(sound: "matchSound", type: ".mp3")
            self.matchCount += 1
            cardsTapped[0].matched = true
            cardsTapped[1].matched = true
        } else {
            playAudio(sound: "noMatchSound", type: ".mp3")
            cardsTapped[0].faceUp = false
            cardsTapped[1].faceUp = false
        }
        // Clear list
        cardsTapped.removeAll()
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
    
    func formatTime(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm:ss"
        let formattedTime = timeFormatter.string(from: date)
        return formattedTime
    }
}
