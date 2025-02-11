//
//  AnkiViewModel.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import Foundation
import SwiftData

// TODO: Change to Model later...

struct DeckStructureNode: Hashable, Identifiable, Comparable {
    
    var id = UUID()
    var name: String
    var children: [DeckStructureNode]?
    var deck: Deck?
    
    /*
        Inserts children recursively, called on root node
     */
    mutating func insert(pathComponents: [String], deck: Deck) {
        guard let name = pathComponents.first else {
            // probably given a root node
            self.deck = deck
            return
        }
        if let existingIndex = children?.firstIndex(where: { $0.name == name }) { // Already has child with same name
            children?[existingIndex].insert(pathComponents: Array(pathComponents.dropFirst()), deck: deck)
        } else { // Create new child because doesn't exist in the array
            var newChildNode = DeckStructureNode(name: name)
            if children == nil {
                children = []
            }
            if pathComponents.count > 1 { // not deck for current node
                newChildNode.insert(pathComponents: Array(pathComponents.dropFirst()), deck: deck)
            } else { // showing last component i.e name of new deck
                newChildNode.deck = deck
            }
            children?.append(newChildNode) // must append after bc appending only makes copy of struct
            children?.sort()
        }
    }
    
    static func < (lhs: DeckStructureNode, rhs: DeckStructureNode) -> Bool {
        lhs.name < rhs.name
    }
}

struct Deck: Codable, Hashable, Comparable {
    
    enum CodingKeys: String, CodingKey {
        case deckID = "deck_id"
        case name = "name"
        case newCount = "new_count"
        case learnCount = "learn_count"
        case reviewCount = "review_count"
        case totalInDeck = "total_in_deck"
    }
    
    var deckID: Int
    var name: String
    var newCount: Int
    var learnCount: Int
    var reviewCount: Int
    var totalInDeck: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deckID = try container.decode(Int.self, forKey: .deckID)
        self.name = try container.decode(String.self, forKey: .name)
        self.newCount = try container.decode(Int.self, forKey: .newCount)
        self.learnCount = try container.decode(Int.self, forKey: .learnCount)
        self.reviewCount = try container.decode(Int.self, forKey: .reviewCount)
        self.totalInDeck = try container.decode(Int.self, forKey: .totalInDeck)
    }
    
    func encode(to encoder: any Encoder) throws { // i don't think i really need it to be encodable
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.deckID, forKey: .deckID)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.newCount, forKey: .newCount)
        try container.encode(self.learnCount, forKey: .learnCount)
        try container.encode(self.reviewCount, forKey: .reviewCount)
        try container.encode(self.totalInDeck, forKey: .totalInDeck)
    }
    
    init (deckID: Int, name: String, newCount: Int, learnCount: Int, reviewCount: Int, totalInDeck: Int) {
        self.deckID = deckID
        self.name = name
        self.newCount = newCount
        self.learnCount = learnCount
        self.reviewCount = reviewCount
        self.totalInDeck = totalInDeck
    }
    
    static func < (lhs: Deck, rhs: Deck) -> Bool {
        lhs.name < rhs.name
    }
}
