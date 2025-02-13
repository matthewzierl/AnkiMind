//
//  DecksView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/6/25.
//

import SwiftData
import SwiftUI


struct AnkiView: View {
    
    enum ViewMode {
        case streaks
        case decks
    }
    @State var mode: ViewMode
    @State var model: ViewModel
    @AppStorage("ipAddress") var ipAddress: String = "Not Set"
    
    @Environment(\.modelContext) var modelContext
    
    init(mode: ViewMode, context: ModelContext) {
        @AppStorage("ipAddress") var ipAddress: String = "Not Set"
        self.mode = mode
        self.model = ViewModel(modelContext: context, ipAddress: ipAddress)
    }
    
    
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
                ToolbarItem(placement: .topBarLeading) {
                    Button("Remove All") {
                        try? modelContext.delete(model: DeckStructureNode.self)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sync") {
                        model.ipAddress = ipAddress
                        model.sync()
                    }
                }
            }
            .navigationTitle(ipAddress/*mode == .streaks ? "Streaks" : "Decks"*/)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

//#Preview {
//    @Previewable @Environment(\.modelContext) var modelContext
//    AnkiView(mode: .decks, modelContext: modelContext)
//}
