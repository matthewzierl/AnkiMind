//
//  DecksView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/6/25.
//

import SwiftUI

struct AnkiView: View {
    
    enum ViewMode {
        case streaks
        case decks
    }
    
    @State var mode: ViewMode
    
    @State var model = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if mode == .streaks {
                    StreaksView(model: model)
                } else { // decks
                    DeckView(model: model)
                }
            }
            
            .toolbar {
                Button("Sync") {
                    model.sync()
                }
            }
            .navigationTitle(mode == .streaks ? "Streaks" : "Decks")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    AnkiView(mode: .decks)
}
