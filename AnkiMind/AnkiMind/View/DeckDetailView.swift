//
//  DeckDetailView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/8/25.
//

import SwiftUI

struct DeckDetailView: View {
    @State var deckNode: DeckStructureNode
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Group {
                    if let deck = deckNode.deck {
                        Text("New: ") +
                        Text("\(deck.newCount)")
                            .foregroundStyle(.blue)
                            .bold()
                        Text("Learn: ") +
                        Text("\(deck.learnCount)")
                            .foregroundStyle(.red)
                            .bold()
                        Text("Review: ") +
                        Text("\(deck.reviewCount)")
                            .foregroundStyle(.green)
                            .bold()
                    } else {
                        Text("Deck Information Not Available")
                    }
                }
                .font(.system(size: 14))
                
            }
            
            .navigationTitle(deckNode.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DeckDetailView(deckNode: DeckStructureNode(name: "Test Deck", deck: Deck(deckID: 123, name: "Test", newCount: 20, learnCount: 25, reviewCount: 30, totalInDeck: 500), isRoot: true))
}
