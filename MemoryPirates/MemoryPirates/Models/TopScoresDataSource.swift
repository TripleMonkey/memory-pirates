//
//  TopScoresDataSource.swift
//  GameOfMemory
//
//  Created by Nigel Krajewski on 12/31/20.
//

import Foundation
import UIKit
import CoreData

class TopScoresDataSource: NSObject, UITableViewDelegate, UITableViewDataSource, TopScoresDataProviderDelegate {
    
    var tableView: UITableView!
    var topScoresDataProvider: TopScoresDataProvider!
    var cellIdentifier: String!
    
    // MARK: Initializer
    init(cellIdentifier: String, tableView: UITableView) {
        self.cellIdentifier = cellIdentifier
        self.tableView = tableView
    }
    
    init(cellIdentifier: String, tableView: UITableView, topScoresDataProvider: TopScoresDataProvider) {
        self.cellIdentifier = cellIdentifier
        self.tableView = tableView
        self.topScoresDataProvider = topScoresDataProvider
        super.init()
        self.topScoresDataProvider.delegate = self
    }
    
    // MARK: Tableview data source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top Scores"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of sections from data provider else return 1
        guard let sections = self.topScoresDataProvider.sections
        else { return 1 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Assign reuse identifier for cell
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        // Convert date to string
        let stringFromDateFormatter = DateFormatter()
        stringFromDateFormatter.dateStyle = .short
        
        let game = self.topScoresDataProvider.object(at: indexPath)
        // Configure cell
        cell.textLabel?.text = "\(indexPath.row + 1). \(game.playerName ?? "Player")  \(doubleToTimeString(timeAsDouble: game.elapsedTime))"
        cell.detailTextLabel?.text = "\(stringFromDateFormatter.string(from: game.timeStarted ?? Date())) Moves: \(game.totalMoves.description)"
        return cell
    }
    
    // MARK: Conversion functions
    
    // Format double to time string
    public func doubleToTimeString(timeAsDouble: Double) -> String {
        // Create formatter to convert double to formatted string
        let componentFormatter = DateComponentsFormatter()
        componentFormatter.includesApproximationPhrase = false
        componentFormatter.allowedUnits = [.hour, .minute, .second]
        componentFormatter.unitsStyle = .positional
        componentFormatter.zeroFormattingBehavior = .pad
        guard let formattedTime = componentFormatter.string(from: timeAsDouble)
        else { return "00:00:00" }
        // return formatted time
        return formattedTime
    }
    
    // Conform to protocol for adding new rows
    func topScoresDataProviderDidInsert(indexPath: IndexPath) {
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
