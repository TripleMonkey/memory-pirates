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
        GameCenterManager().accessPoint.isActive = false
        avPlayer.playAudio(sound: "launchSound", type: ".mp3")
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
    @Published var currentElapsedTimeLabel = "00:00.00"
    // Array to hold tapped cards
    @Published var cardsTapped = [Card]()
    
    @Published var previewCards = false
    
    // Game start time
    var startTime: Date?
    
    // Context
    var managedObjectContext = AppDelegate.sharedContext
    
    // Audio player
    var avPlayer = AVPlayerModel()
    
    // MARK: Start game
    func startGame() {
        // Reset game values
        moves = 0
        matchCount = 0
        // Toggle play button
        playButtonIsActive.toggle()
        // 5 second preview of card values
        previewAll(cards: currentDeck.cards)
        avPlayer.playAudio(sound: "countDownSound", type: ".mp3")
        startTime = .now + 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [self] in
            // Make sure game not reset before sterating timer
            if startTime != nil {
                // Start elapsed time counter
                elapsedTimer = Timer.scheduledTimer(timeInterval: 0.09, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
            }
        })
    }
    
    // MARK: Game Play
    // Function to show all cards
    func previewAll(cards: [Card]) {
        // Show card value
        for i in 0..<cards.count {
            cards[i].faceUp = true
            self.previewCards.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [self] in
            // Hide card value
            for i in 0..<cards.count {
                currentDeck.cards[i].faceUp = false
            }
            self.previewCards.toggle()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: { [self] in
            if cardsTapped[0].value == cardsTapped[1].value {
                avPlayer.playAudio(sound: "matchSound", type: ".mp3")
                self.matchCount += 1
                cardsTapped[0].matched = true
                cardsTapped[1].matched = true
                self.endGame()
            } else {
                avPlayer.playAudio(sound: "noMatchSound", type: ".mp3")
                cardsTapped[0].faceUp = false
                cardsTapped[1].faceUp = false
            }
            // Clear list
            cardsTapped.removeAll()
        })
    }
    
    // Function to diplay elapsed time
    @objc func updateElapsedTime() {
        // If game time is nil stop timer
        if startTime == nil {
            elapsedTimer?.invalidate()
        }
        currentElapsedTimeLabel = LeaderboardViewModel.shared.formattedTime(seconds: startTime?.timeIntervalSinceNow ?? 0)
    }
    
    
    // MARK: End Game
    // Function to end game
    private func endGame() {
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
        
        // End game animation and audio
        avPlayer.playAudio(sound: "completeSound", type: ".mp3")
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
        // Stop elapsed timer by setting strat time to nil
        startTime = nil
        cardsTapped.removeAll()
        currentDeck = DeckViewModel().prepareNewDeck(withCardCount: 30)
        playButtonIsActive = true
        // Stop any audio
        avPlayer.audioPlayer?.stop()
    }
}
