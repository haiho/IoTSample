//
//  CustomButton.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/07/2025.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var colorBG  = Color.blue
    var colorForeground = Color.white
    

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorBG)
                .foregroundColor(colorForeground)
                .cornerRadius(8)
        }
    }
}

