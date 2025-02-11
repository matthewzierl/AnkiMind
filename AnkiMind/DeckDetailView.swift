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
                        Text("\(deck.new_count)")
                            .foregroundStyle(.blue)
                            .bold()
                        Text("Learn: ") +
                        Text("\(deck.learn_count)")
                            .foregroundStyle(.red)
                            .bold()
                        Text("Review: ") +
                        Text("\(deck.review_count)")
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
    DeckDetailView(deckNode: DeckStructureNode(name: "Test Deck", deck: Deck(deck_id: 123, name: "Example Deck", new_count: 20, learn_count: 5, review_count: 75, total_in_deck: 2000)))
}
