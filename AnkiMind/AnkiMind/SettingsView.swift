//
//  SettingsView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import SwiftUI

struct SettingsView: View {
    
    @State var ipAddress: String = UserDefaults.standard.string(forKey: "ipAdress") ?? ""
    @State private var octet1: String = ""
    @State private var octet2: String = ""
    @State private var octet3: String = ""
    @State private var octet4: String = ""
    @State private var selectedTheme: Theme = .lime
    
    enum Theme: String, CaseIterable {
        case lime = "Lime"
        case olive = "Olive"
        case ice = "Ice"
        case magenta = "Magenta"
        case flame = "Flame"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("AnkiConnect IP Address") {
                    HStack {
                        TextField("Octet 1", text: $octet1)
                        Text(".")
                        TextField("Octet 2", text: $octet1)
                        Text(".")
                        TextField("Octet 3", text: $octet1)
                        Text(".")
                        TextField("Octet 4", text: $octet1)
                    }
                }
                
                Section("Appearance") {
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(Theme.allCases, id: \.self) { theme in
                            Text(theme.rawValue)
                        }
                    }
                }
                
                Section() {
                    Button("Save") {
                        // TODO: save
                    }
                }
            }
            
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
