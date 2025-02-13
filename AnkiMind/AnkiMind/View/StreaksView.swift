//
//  StreaksView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import SwiftData
import SwiftUI

struct StreaksView: View {
    
    @Bindable var model: AnkiView.ViewModel
    @Query(filter: #Predicate<DeckStructureNode> { node in
        node.isRoot
    }) var rootNodes: [DeckStructureNode] // root nodes
    
    var body: some View {
        VStack {
            Text("Number of root decks: \(rootNodes.count)")
        }
    }
}

//#Preview {
//    @Previewable @Environment(\.modelContext) var context
//    @Previewable @Query(filter: #Predicate<DeckStructureNode> { node in
//        node.isRoot
//    }) var rootNodes: [DeckStructureNode] // root nodes
//    StreaksView(model: AnkiView.ViewModel(modelContext: context, rootNodes: rootNodes))
//}
