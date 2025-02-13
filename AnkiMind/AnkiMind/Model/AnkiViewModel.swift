//
//  AnkiViewModel.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import Foundation
import SwiftData

@Model
final class DeckStructureNode: Hashable, Comparable {
    
    var name: String
    var isRoot: Bool = false
    @Relationship(inverse: \DeckStructureNode.children) var parent: DeckStructureNode?
    @Relationship(deleteRule: .cascade) var children: [DeckStructureNode]?
    @Relationship(deleteRule: .cascade) var deck: Deck?
    var nonEmptyChildren: [DeckStructureNode]? {
        let sortedChildren = children?.sorted()
        return sortedChildren?.isEmpty == false ? sortedChildren : nil
    }
    
    init(name: String, children: [DeckStructureNode]? = nil, deck: Deck? = nil, isRoot: Bool) {
        self.name = name
        self.isRoot = isRoot
        self.children = children
        self.deck = deck
    }
    
    /*
        Inserts children recursively, called on root node
     */
    func insert(pathComponents: [String], deck: Deck, modelContext: ModelContext) {
        if pathComponents.count == 0 { // given a root node
            self.deck = deck
            modelContext.insert(self)
            return
        }
        let currentNodeName = pathComponents[0]
        if let existingIndex = children?.firstIndex(where: { $0.name == currentNodeName }) { // Already has child with same name
            children?[existingIndex].insert(pathComponents: Array(pathComponents.dropFirst()), deck: deck, modelContext: modelContext)
        } else { // Create new child because doesn't exist in the array
            let newChildNode = DeckStructureNode(name: currentNodeName, isRoot: false)
            newChildNode.parent = self
            if children == nil || children!.isEmpty {
                children = [newChildNode]
            } else {
                children!.append(newChildNode)
            }
            if pathComponents.count > 1 { // continue down path until deck assignment
                newChildNode.insert(pathComponents: Array(pathComponents.dropFirst()), deck: deck, modelContext: modelContext)
            } else { // last node in path
                newChildNode.deck = deck
            }
            modelContext.insert(newChildNode)
        }
    }
    
    static func < (lhs: DeckStructureNode, rhs: DeckStructureNode) -> Bool {
        lhs.name < rhs.name
    }
    
    static let sampleData: [DeckStructureNode] = [
        DeckStructureNode(name: "Languages", children: [
            DeckStructureNode(name: "Japanese", deck: Deck(deckID: 1, name: "Japanese", newCount: 10, learnCount: 5, reviewCount: 20, totalInDeck: 35), isRoot: false),
            DeckStructureNode(name: "Spanish", deck: Deck(deckID: 2, name: "Spanish", newCount: 8, learnCount: 3, reviewCount: 15, totalInDeck: 26), isRoot: false)
        ], isRoot: true),
        DeckStructureNode(name: "Science", children: [
            DeckStructureNode(name: "Physics", deck: Deck(deckID: 3, name: "Physics", newCount: 6, learnCount: 4, reviewCount: 12, totalInDeck: 22), isRoot: false),
            DeckStructureNode(name: "Biology", deck: Deck(deckID: 4, name: "Biology", newCount: 7, learnCount: 2, reviewCount: 10, totalInDeck: 19), isRoot: false)
        ], isRoot: true),
        DeckStructureNode(name: "History", deck: Deck(deckID: 5, name: "History", newCount: 5, learnCount: 3, reviewCount: 8, totalInDeck: 16), isRoot: true)
    ]
}

@Model
final class Deck: Codable, Hashable, Comparable {
    
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
