//
//  DeckView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import SwiftUI

struct DeckView: View {
    
    @Bindable var model: AnkiView.ViewModel
    
    var body: some View {
        Form {
            List(model.deckStructure.sorted(), children: \.children) { structure in
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
        }
    }
}

#Preview {
    @Previewable @State var model = AnkiView.ViewModel()
    DeckView(model: model)
}
