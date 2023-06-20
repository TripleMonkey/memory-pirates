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
    var cardValues: [Int]
    var startTime: Date?
    
    // MARK: Initializer
    init(cardValues: [Int]) {
        self.cardValues = cardValues
    }
}
