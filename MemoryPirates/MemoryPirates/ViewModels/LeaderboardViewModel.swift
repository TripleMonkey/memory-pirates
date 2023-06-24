//
//  LeaderboardViewModel.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/24/23.
//

import Foundation
import CoreData

final class LeaderboardViewModel: ObservableObject {
    
    // Shared Context
    var context = AppDelegate.sharedContext
    
    // MARK: Published variables
    @Published var gameHistory: [Score] = []
    
    // Singleton pattern to maintain single source of truth
    static var shared = LeaderboardViewModel()
    private init() {
        fetchScores()
    }
    
    // Core Data functions
    // MARK: Create
    func createNewScore(time: Double, player: String, timeStarted: Date, totalMoves: Int16) {
        // Create new plantCD
        let object: Score = Score(entity: Score.entity(), insertInto: context)
        object.elapsedTime = time
        object.playerName = player
        object.timeStarted = timeStarted
        object.totalMoves = totalMoves
        // Save to local list
        gameHistory.append(object)
        // Save to CD
        saveData()
    }
    
    // MARK: Retrieve
    func fetchScores() {
        let request = NSFetchRequest<Score>(entityName: "Score")
        DispatchQueue.main.async { [self] in
            do {
                gameHistory = try context.fetch(request)
                print("FETCH SUCCESS: Games Played= \(gameHistory.count)")
            } catch let error {
                print("ERROR FETCHING: \(error)")
            }
        }
    }
    
    // MARK: Update
    func saveData() {
        DispatchQueue.main.async { [self] in
            do {
                if context.hasChanges {
                    try context.save()
                    fetchScores()
                }
            } catch let error {
                print("Another Error Saving: \(error)")
            }
        }
    }
    
    // MARK: Delete
    func deleteGame(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = gameHistory[index]
        context.delete(entity)
        saveData()
    }
    
    
}
