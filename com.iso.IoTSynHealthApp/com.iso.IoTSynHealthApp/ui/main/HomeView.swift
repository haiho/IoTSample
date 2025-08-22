//
//  ContentView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 20/8/25.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        BaseScrollVStrack(backgroundColor: Color.red.opacity(0.2)) {
            ForEach(1..<6) { index in
                Text("Item \(index)")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    HomeView()
}
