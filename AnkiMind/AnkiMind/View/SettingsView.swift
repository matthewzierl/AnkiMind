//
//  SettingsView.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("ipAddress") var ipAddress: String = "Not Set"
    @AppStorage("octet1") private var octet1: String = ""
    @AppStorage("octet2") private var octet2: String = ""
    @AppStorage("octet3") private var octet3: String = ""
    @AppStorage("octet4") private var octet4: String = ""
//    @State private var selectedTheme: String = UserDefaults.standard.string(forKey: "selectedTheme") ?? "Lime"
    @State private var madeChanges: Bool = false
    
//    enum Theme: String, CaseIterable {
//        case lime = "Lime"
//        case olive = "Olive"
//        case ice = "Ice"
//        case magenta = "Magenta"
//        case flame = "Flame"
//    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("AnkiConnect IP Address") {
                    HStack {
                        TextField("Octet 1", text: $octet1)
                            .onChange(of: octet1) {
                                madeChanges = true
                            }
                        Text(".")
                        TextField("Octet 2", text: $octet2)
                            .onChange(of: octet2) {
                                madeChanges = true
                            }
                        Text(".")
                        TextField("Octet 3", text: $octet3)
                            .onChange(of: octet3) {
                                madeChanges = true
                            }
                        Text(".")
                        TextField("Octet 4", text: $octet4)
                            .onChange(of: octet4) {
                                madeChanges = true
                            }
                    }
                }
                
                Section("Appearance") {
//                    Picker("Theme", selection: $selectedTheme) {
//                        ForEach(Theme.allCases, id: \.self) { theme in
//                            Text(theme.rawValue)
//                        }
//                    }
                }
                
                Section() {
                    Button("Save") {
                        let newIpAddress = "\(octet1).\(octet2).\(octet3).\(octet4)"
                        UserDefaults.standard.set(newIpAddress, forKey: "ipAddress")
                        UserDefaults.standard.set(octet1, forKey: "octet1")
                        UserDefaults.standard.set(octet2, forKey: "octet2")
                        UserDefaults.standard.set(octet3, forKey: "octet3")
                        UserDefaults.standard.set(octet4, forKey: "octet4")
                        ipAddress = newIpAddress
                        madeChanges = false
                    }
                    .disabled(!madeChanges)
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
