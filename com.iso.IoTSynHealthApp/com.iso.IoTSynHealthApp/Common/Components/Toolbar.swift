//
//  Toolbar.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//

import SwiftUI

struct ToolbarCenter: ToolbarContent {
    var title: LocalizedStringKey

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
        }
    }
}



