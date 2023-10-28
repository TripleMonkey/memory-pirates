//
//  DeckViewModel.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 7/4/23.
//

import Foundation
class DeckViewModel {
    
    // MARK: Create Game Deck
    // Reset or setup new game
    
    /// Prepares new deck with randomized card values
    /// - Parameter deckSize: Number of cards to be used in game
    /// - Returns: new Deck object with random card pair values
    func prepareNewDeck(withCardCount deckSize: Int) -> Deck {
        // Create new deck of cards
        Deck(cards: assignValues(cardCount: deckSize))
    }
    
    //Function to assign random values to game cards
    private func assignValues(cardCount: Int) -> [Card] {
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
    private func createIntArray(withCountOf count: Int) -> [Int] {
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
    private func cards(from strings: [String]) -> [Card]{
        var cards: [Card] = []
        for i in 0..<strings.count {
            cards.append(Card(imageString: strings[i]))
        }
        return cards
    }
}
