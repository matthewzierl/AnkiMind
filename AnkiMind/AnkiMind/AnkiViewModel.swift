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

struct Deck: Decodable, Hashable, Comparable {
    var deck_id: Int
    var name: String
    var new_count: Int
    var learn_count: Int
    var review_count: Int
    var total_in_deck: Int
    
    static func < (lhs: Deck, rhs: Deck) -> Bool {
        lhs.name < rhs.name
    }
}
