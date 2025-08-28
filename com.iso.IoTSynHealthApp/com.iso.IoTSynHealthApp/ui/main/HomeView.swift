//
//  ContentView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 20/8/25.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        BaseScrollVStrack {
            VStack {
                //MARK:  info and circle chart
                Grid {
                    GridRow {
                        // Phần 1: VStack (1/3)
                        VStack(alignment: .leading, spacing: 4) {
                            VStack {
                                CustomText("Calories").color(.red)
                                CustomText("123")
                            }
                            VStack {
                                CustomText("Activity").color(.green)
                                CustomText("123")
                            }
                            VStack {
                                CustomText("Steps").color(.blue)
                                CustomText("123")
                            }
                            VStack {
                                CustomText("Stand").color(.orange)
                                CustomText("123")
                            }
                        }
                        .frame(alignment: .leading)
                        .gridCellColumns(1)


                        // Phần 2: ZStack (2/3)
                        ZStack(alignment: .trailing) {
                            ProgressCircleView(
                                progress: .constant(100),
                                goal: 800,
                                color: .red
                            )
                            ProgressCircleView(
                                progress: .constant(200),
                                goal: 800,
                                color: .green
                            ).padding(AppPadding.withProgress)

                            ProgressCircleView(
                                progress: .constant(300),
                                goal: 600,
                                color: .yellow
                            ).padding(2 * AppPadding.withProgress)

                            ProgressCircleView(
                                progress: .constant(250),
                                goal: 600,
                                color: .orange
                            ).padding(3 * AppPadding.withProgress)
                        }
                        .frame(maxHeight: 200, alignment: .trailing)
                        .gridCellColumns(2)  // tổng cộng 3 phần

                    }
                }
                .gridColumnAlignment(.leading)

            }.padding(.horizontal)

            //MARK:  2 card activity

        }
    }
}

#Preview {
    HomeView()
}
