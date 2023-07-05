/*
 Student:    Nigel Krajewski
 Term:       202012
 Course:     MDV3730-O
 */

//
//  Deck.swift
//  GameOfMemory
//
//  Created by Nigel Krajewski on 12/4/20.
//

import Foundation
import UIKit
import CoreData

class Deck: Identifiable {
    
    //MARK: Properties
    var id = UUID()
    var cards: [Card] = []
    
    // MARK: Initializer
    init(cards: [Card]) {
        self.cards = cards
    }
}
