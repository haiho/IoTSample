//
//  ActivityCard.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 27/8/25.
//

import SwiftUI

struct ActivityCard: View {
    @State var activity: Activity

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6).cornerRadius(15)
            VStack {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 8) {
                        CustomText(activity.title).fontNormalBold
                        CustomText("lbl_this_week".localized)
                    }
                    Spacer()
                    Image(systemName: activity.image).foregroundColor(
                        activity.tintColor
                    )
                }

                CustomText(activity.amount).title.centerAligned.padding(10)

            }.padding(.all)

        }
    }
}

#Preview {
    ActivityCard(
        activity: Activity(
            type: .oxygenSaturation,
            title: "Oxygen",
            subTitle: "This Week",
            image: "lungs.fill",
            tintColor: .purple,
            amount: "292"
        )
    )
}
