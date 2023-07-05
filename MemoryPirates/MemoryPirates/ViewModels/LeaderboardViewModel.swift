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
    @Published var bestTime: String = "00:00.00"
    @Published var sortSelector: SortValue = .bestTime
    
    // Singleton pattern to maintain single source of truth
    static var shared = LeaderboardViewModel()
    private init() {
        fetchScores()
    }
    
    // MARK: Date Formatter
    // Func to return formatted string
    func formattedTime(seconds: Double) -> String {
        // multiply by 1000 to catpture miliseconds in int
        let time: Int = Int(seconds*(-100))
        // Seperate int into minutes, seconds, milliseconds
        let minSecMil = (((time/100)%3600)/60,
                         ((time/100)%3600)%60,
                         time%100)
        // Convert to strings
        let min = leadingZeroStringFormat(from: minSecMil.0)
        let sec = leadingZeroStringFormat(from: minSecMil.1)
        let mil = leadingZeroStringFormat(from: minSecMil.2)
        
        // Create return string from minSecMil
        var timeString: String
        if minSecMil.0 > 0 {
            timeString = "\(min):\(sec).\(mil)"
        } else {
            timeString = "00:\(sec).\(mil)"
        }
        return timeString
    }
    // Func to add leading zero to int under 10
    func leadingZeroStringFormat(from int: Int) -> String {
        if int < 10 {
            return "0\(int)"
        } else {
            return "\(int)"
        }
    }
    
    // MARK: Sorting funtion
    func sortGameHistory(scores: [Score], by sortBy: SortValue) -> [Score] {
        // Sort by best time
        let bestTimes = scores.sorted {
            $0.elapsedTime > $1.elapsedTime
        }
        // Make sure array not empty
        if !bestTimes.isEmpty {
            // Update bestTime param
            bestTime = formattedTime(seconds: bestTimes[0].elapsedTime)
        }
        var sortedScores: [Score] = []
        switch sortBy {
        case .bestTime:
            sortedScores = bestTimes
        case .fewestMoves:
            sortedScores = scores.sorted {
                var isNext = $0.totalMoves < $1.totalMoves
                if $0.totalMoves == $1.totalMoves {
                    isNext = $0.elapsedTime > $1.elapsedTime
                }
                return isNext
            }
        case .newestGames:
            sortedScores = scores.sorted {
                $0.timeStarted ?? .now > $1.timeStarted ?? .now + 1
            }
        case .oldestGames:
            sortedScores = scores.sorted {
                $0.timeStarted ?? .now < $1.timeStarted ?? .now + 1
            }
        }
        return sortedScores
    }
    
    // MARK: Core Data functions
    // Create
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
    // Retrieve
    func fetchScores() {
        let request = NSFetchRequest<Score>(entityName: "Score")
        DispatchQueue.main.async { [self] in
            do {
                let history = try context.fetch(request)
                gameHistory = sortGameHistory(scores: history, by: sortSelector)
                
                print("FETCH SUCCESS: Games Played= \(gameHistory.count)")
            } catch let error {
                print("ERROR FETCHING: \(error)")
            }
        }
    }
    // Update
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
    // Delete
    func deleteGame(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = gameHistory[index]
        context.delete(entity)
        saveData()
    }
}

enum SortValue {
    case bestTime, fewestMoves, newestGames, oldestGames
}
