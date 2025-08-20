//
//  ContentView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 20/8/25.
//
import SwiftUI

struct ContentView: View {
    @State private var showSideMenu = false

    var body: some View {
        NavigationView {
            List(1..<6) { index in
                Text("Item \(index)")
            }
            .navigationBarTitle("Dashboard", displayMode: .inline)
            .navigationBarItems(
                leading: (Button(action: {
                    withAnimation {
                        self.showSideMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                })
            )
        }.sideMenu(isShowing: $showSideMenu) {
            SideMenuContent(isShowing: $showSideMenu)
        }
    }
}
