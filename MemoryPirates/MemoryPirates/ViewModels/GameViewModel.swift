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
    @Published var playButtonIsActive: Bool = true
    // String to hold current game elapsed time
    @Published var currentElapsedTimeLabel = "0"
    // Array to hold tapped cards
    @Published var cardsTapped = [Card]()
    
    // Game start time
    var startTime: Date?
    
    // Context
    var managedObjectContext = AppDelegate.sharedContext
    
    // Audio player
    var audioPlayer = AVPlayerModel()
    
    // MARK: Start game
    // Function to start new game
    func startGame() {
        // Toggle play button
        playButtonIsActive.toggle()
        // 5 second preview of card values
        previewAll(cards: currentDeck.cards)
        startTime = .now
        
        audioPlayer.playAudio(sound: "countDownSound", type: ".mp3")
        if startTime != nil {
            // Start elapsed time counter
            self.elapsedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        }
    }
    
    // MARK: Game Play
    // Function to show all cards
    func previewAll(cards: [Card]) {
        // Show card value
        for i in 0..<cards.count {
            cards[i].faceUp = true
            print("Card \(i) is faceUp: \(cards[i].faceUp)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [self] in
            // Hide card value
            for i in 0..<cards.count {
                currentDeck.cards[i].faceUp = false
            }
            // Initialize game start time
            startTime = Date.now
        })
    }
    
    // Func to record card taps
    func handleCardTap(tappedCard: Card) {
        guard cardsTapped.count < 2, !playButtonIsActive else { return }
        // Add card to list
        if cardsTapped.count < 2 {
            cardsTapped.append(tappedCard)
            tappedCard.faceUp = true
            moves += 1
        }
        compareCards()
    }
    
    private func compareCards() {
        guard cardsTapped.count == 2 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: { [self] in
            if cardsTapped[0].value == cardsTapped[1].value {
                audioPlayer.playAudio(sound: "matchSound", type: ".mp3")
                self.matchCount += 1
                cardsTapped[0].matched = true
                cardsTapped[1].matched = true
                self.endGame()
            } else {
                audioPlayer.playAudio(sound: "noMatchSound", type: ".mp3")
                cardsTapped[0].faceUp = false
                cardsTapped[1].faceUp = false
            }
            // Clear list
            cardsTapped.removeAll()
        })
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
        // Finalize game values and add new score to core data
        let newScore = NSEntityDescription.insertNewObject(forEntityName: "Score", into: self.managedObjectContext) as! Score
        newScore.totalMoves = Int16(moves)
        newScore.timeStarted = time
        newScore.playerName = UserDefaults.standard.string(forKey: "name")
        newScore.elapsedTime = time.timeIntervalSinceNow
        
        // Add score to game center leaderboard
        // Pass elapsed time multipled by 100 to format for positive value in miliseconds
        GameCenterManager().reportScore(chests: moves, timeInMilliseconds: Int(newScore.elapsedTime*100))
        
        // Stop timer
        elapsedTimer?.invalidate()
        // End game animation and audio
        audioPlayer.playAudio(sound: "completeSound", type: ".mp3")
        // Save to CoreData
        do {
            try managedObjectContext.save()
        }
        catch {
            print("Error saving score in endGame function.")
        }
        // Reset values
        resetGame()
    }
    
    func resetGame() {
        moves = 0
        matchCount = 0
        cardsTapped.removeAll()
        currentDeck = DeckViewModel().prepareNewDeck(withCardCount: 30)
        playButtonIsActive = true
    }
    
    func formatTime(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm:ss"
        let formattedTime = timeFormatter.string(from: date)
        return formattedTime
    }
}
