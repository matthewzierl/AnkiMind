//
//  InputNumberBox.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/7/25.
//

import SwiftUI

struct InputNumberBox: View {
    
    var title: String
    var textColor: Color
    @Binding var number: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
            Spacer()
            TextField("", value: $number, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(textColor)
                .bold()
        }
    }
}

#Preview {
    @Previewable @State var num = 0
    let title = "Test"
    let color: Color = .blue
    InputNumberBox(title: title, textColor: color, number: $num)
}
