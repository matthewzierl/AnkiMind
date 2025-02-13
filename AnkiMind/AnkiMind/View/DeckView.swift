//
//  DeckView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import SwiftData
import SwiftUI

struct DeckView: View {
    
    @Bindable var model: AnkiView.ViewModel
    @Query(filter: #Predicate<DeckStructureNode> { node in
        node.isRoot
    }) var rootNodes: [DeckStructureNode] // root nodes
    @Query var allNodes: [DeckStructureNode] // root nodes
    
    var body: some View {
        Form {
            Section {
                List(rootNodes.sorted(), children: \.nonEmptyChildren) { structure in
                    NavigationLink(destination: DeckDetailView(deckNode: structure)) {
                        HStack {
                            Text(structure.name)
                                .font(.system(size: 14))
                            Spacer()
                            Text(structure.deck?.newCount.description ?? "0")
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(.blue)
                                .font(.system(size: 14))
                                .bold()
                            Text(structure.deck?.learnCount.description ?? "0")
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(.red)
                                .font(.system(size: 14))
                                .bold()
                            Text(structure.deck?.reviewCount.description ?? "0")
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(.green)
                                .font(.system(size: 14))
                                .bold()
                        }
                    }
                }
            } footer: {
                Text("Root Decks: \(rootNodes.count), Total Decks: \(allNodes.count)")
            }
        }
    }
}

//#Preview {
//    @Previewable @Environment(\.modelContext) var context
//    @Previewable @Query(filter: #Predicate<DeckStructureNode> { node in
//        node.isRoot
//    }) var rootNodes: [DeckStructureNode] // root nodes
//    DeckView(model: AnkiView.ViewModel(modelContext: context, rootNodes: rootNodes))
//}
