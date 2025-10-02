//
//  Activity.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//
import SwiftUI

// Dùng class để update  @Published var amount: String mà struct không làm được

class Activity: ObservableObject, Identifiable {
    let id = UUID()
    let type: HealthDataType
    let title: String
    let subTitle: String
    let image: String
    let tintColor: Color

    @Published var amount: String

    init(
        type: HealthDataType,
        title: String,
        subTitle: String,
        image: String,
        tintColor: Color = .white,
        amount: String = "0"
    ) {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.tintColor = tintColor
        self.amount = amount
    }
}
// Thêm Hashable conform riêng biệt (bên ngoài class)
extension Activity: Hashable {
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
