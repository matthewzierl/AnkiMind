//
//  ProfileView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var viewModel = ViewModel()
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    InputNumberBox(title: "New Cards", textColor: .blue, number: $viewModel.numNewCards)
                    InputNumberBox(title: "Reviews", textColor: .green, number: $viewModel.numReviews)
                } header: {
                    Text("Personal Goals")
                } footer: {
                    Text("These are goals you plan to achieve every day.")
                }
                Section() {
                    
                } header: {
                    Text("Track Decks")
                } footer: {
                    Text("Choose which decks you wish to hold accountability for.")
                }
                
                Button("Save") {
                    // TODO: save
                }
                
                
            }
            
            .toolbar {
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileView()
}
