//
//  StreaksView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import SwiftUI

struct StreaksView: View {
    
    @Bindable var model: AnkiView.ViewModel
    
    var body: some View {
        VStack {
            Text("TODO: Streaks View")
        }
    }
}

#Preview {
    @Previewable @State var model = AnkiView.ViewModel()
    StreaksView(model: model)
}
