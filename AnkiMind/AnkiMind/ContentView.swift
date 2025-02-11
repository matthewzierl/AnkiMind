//
//  ContentView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/6/25.
//

import SwiftUI

struct ContentView: View {
    
    enum TabSelection {
        case streaks
        case decks
        case profile
    }
    
    @State private var tabSelection: TabSelection = .streaks
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Streaks", systemImage: "flame", value: .streaks) {
                AnkiView(mode: .streaks)
            }
            Tab("Decks", systemImage: "square.stack", value: .decks) {
                AnkiView(mode: .decks)
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
