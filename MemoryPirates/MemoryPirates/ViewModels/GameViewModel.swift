//
//  GameViewModel.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import Foundation
import UIKit
import CoreData
import AVKit

final class GameViewModel: ObservableObject {
    
    // Singlton pattern to maintain single game vm instance
    static let shared = GameViewModel()
    private init() {
        currentDeck = DeckViewModel().prepareNewDeck(withCardCount: 30)
    }
    
    @Published var currentDeck: Deck
    // Timer for elapsed time
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
    
    // Game start time
    var startTime: Date?
    
    // Context
    var managedObjectContext = AppDelegate.sharedContext
    
    // Audio player
    var audioPlayer: AVAudioPlayer?

    // MARK: Start game
    // Function to start new game
    func startGame() {
        //guard let game = currentGame else { return }
        // Toggle play button
        playButtonIsActive.toggle()
        // 5 second preview of card values
        // previewAll(cards: game.cards)
        startTime = .now
        
        playAudio(sound: "countDownSound", type: ".mp3")
        //        if game.startTime != nil {
        //            // Start elapsed time counter
        //            self.elapsedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        //        }
    }
    
    // MARK: Game Play
    // Function to show all cards
    func previewAll(cards: [Card]) {
        for i in 0..<cards.count {
            // Show card value
            cards[i].faceUp = true
            print("Card \(i) is faceUp: \(cards[i].faceUp)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [self] in
            for i in 0..<cards.count {
                // Hide card value
                currentDeck.cards[i].faceUp.toggle()
                print("Card \(i) is faceUp: \(cards[i].faceUp)")
            }
            // Initialize game start time
            startTime = Date.now
        })
    }
    
    // Func to record card taps
    func handleCardTap(tappedCard: Card) {
        guard !playButtonIsActive else { return }
        // Add card to list
        if cardsTapped.count < 2 {
            cardsTapped.append(tappedCard)
            tappedCard.faceUp = true
            moves += 1
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
            self.endGame()
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
        currentElapsedTimeLabel = componentFormatter.string(from: startTime?.timeIntervalSinceNow ?? 0) ?? "0"
    }
    
    
    // MARK: End Game
    // Function to end game
    func endGame() {
        guard let time = startTime, matchCount == 15 else { return }
        print("Match count: \(matchCount)")
        // Finalize game values and add new score to core data
        let newScore = NSEntityDescription.insertNewObject(forEntityName: "Score", into: self.managedObjectContext) as! Score
        newScore.totalMoves = Int16(moves)
        newScore.timeStarted = time
        newScore.playerName = UserDefaults.standard.string(forKey: "name")
        newScore.elapsedTime = time.timeIntervalSinceNow
        
        // Add score to game center leaderboard
        // Pass elapsed time multipled by 100 to format for positive value in miliseconds
        GameCenterManager().reportScore(chests: moves, timeInMilliseconds: Int(newScore.elapsedTime*(100)))
        
        // Stop timer
        elapsedTimer?.invalidate()
        // End game animation and audio
        playAudio(sound: "completeSound", type: ".mp3")
        // Save to CoreData
        do {
            try managedObjectContext.save()
        }
        catch {
            print("Error saving score in endGame function.")
        }
        // Reset values
        resetGame()
        // TODO: Reload table view
        
    }
    
    func resetGame() {
        moves = 0
        matchCount = 0
        cardsTapped.removeAll()
        currentDeck = DeckViewModel().prepareNewDeck(withCardCount: 30)
    }
    
    func formatTime(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm:ss"
        let formattedTime = timeFormatter.string(from: date)
        return formattedTime
    }
    
    // MARK: Audio Player
    // Function to play sound from parameters entered
    func playAudio(sound: String, type: String) {
        // get path to sound
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            // Use do-try to get sound from path
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                // Play sound
                audioPlayer?.play()
            }
            catch {
                // Print error if unsuccessful
                print("Error: Sound file not found. Check path.")
            }
        }
    }
}
