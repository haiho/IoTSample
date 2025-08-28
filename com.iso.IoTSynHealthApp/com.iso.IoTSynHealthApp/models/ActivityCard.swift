//
//  ActivityCard.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 27/8/25.
//

import SwiftUI

struct Activity {
    let id: Int
    let title: String
    let subTitle: String
    let image: String
    let tintColor: Color
    let amount: String
}

struct ActivityCard: View {
    @State var activity: Activity

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6).cornerRadius(15)
            VStack {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 8) {
                        CustomText(activity.title)
                        CustomText(activity.amount)
                    }
                    Spacer()
                    Image(systemName: activity.image).foregroundColor(
                        activity.tintColor
                    )
                }

                CustomText("621")

            }

        }.padding()
    }
}

#Preview {
    ActivityCard(
        activity: Activity(
            id: 1,
            title: "title",
            subTitle: "subTitle",
            image: "figure.walk",
            tintColor: .blue,
            amount: "292"
        )
    )
}
