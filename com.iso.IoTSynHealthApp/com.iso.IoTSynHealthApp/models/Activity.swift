//
//  Activity.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//
import SwiftUI
class Activity: ObservableObject, Identifiable {
    let id = UUID()
    let type: HealthDataType
    let title: String
    let subTitle: String
    let image: String
    let tintColor: Color

    @Published var amount: String

    init(type: HealthDataType, title: String, subTitle: String, image: String, tintColor: Color = .white, amount: String = "0") {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.tintColor = tintColor
        self.amount = amount
    }
}
//struct Activity {
//    let id = UUID()
//    let title: String
//    let subTitle: String
//    let image: String
//    let tintColor: Color
//    let amount: String
//    
//    init(title: String, subTitle: String, image: String, tintColor: Color = .gray, amount: String) {
//        self.title = title
//        self.subTitle = subTitle
//        self.image = image
//        self.tintColor = tintColor
//        self.amount = amount
//    }
//}
