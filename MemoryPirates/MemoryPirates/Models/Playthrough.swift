/*
 Student:    Nigel Krajewski
 Term:       202012
 Course:     MDV3730-O
 */

//
//  Playthrough.swift
//  GameOfMemory
//
//  Created by Nigel Krajewski on 12/4/20.
//

import Foundation
import UIKit
import CoreData


class Playthrough {
    
    //MARK: Properties
    var cardValues: [String] = []
    var startTime: Date?
    
    // MARK: Initializer
    init(gameSize: Int) {
        cardValues = assignValues(cardCount: gameSize)
        startTime = Date.now
    }
    
    //Function to assign random values to game cards
    private func assignValues(cardCount: Int) -> [String] {
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
        return imageStrings
    }
}
