//
//  ContentView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/6/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    
    enum TabSelection {
        case streaks
        case decks
        case profile
    }
    
    @State private var tabSelection: TabSelection = .streaks
    @Environment(\.modelContext) var context
    @Query(filter: #Predicate<DeckStructureNode> { node in
        node.isRoot
    }) var rootNodes: [DeckStructureNode] // root nodes
    @AppStorage("ipAddress") var ipAddress: String = "Not Set"
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Streaks", systemImage: "flame", value: .streaks) {
                AnkiView(mode: .streaks, context: context)
            }
            Tab("Decks", systemImage: "square.stack", value: .decks) {
                AnkiView(mode: .decks, context: context)
            }
            Tab("Profile", systemImage: "person", value: .profile) {
                ProfileView()
            }
        }
    }
}

#Preview {
    ContentView()
}
