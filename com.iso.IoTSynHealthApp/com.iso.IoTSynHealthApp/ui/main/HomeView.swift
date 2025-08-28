//
//  ContentView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 20/8/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
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
                                CustomText("\(homeViewModel.calories)")

                            }
                            VStack {
                                CustomText("Activity").color(.green)
                                CustomText("\(homeViewModel.activity)")
                            }
                            VStack {
                                CustomText("Steps").color(.blue)
                                CustomText("\(homeViewModel.steps)")
                            }
                            VStack {
                                CustomText("Stand").color(.orange)
                                CustomText("\(homeViewModel.stand)")
                            }
                        }
                        .gridCellColumns(1)
                        Spacer()

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
                        .gridCellColumns(2)

                    }
                }
                .gridColumnAlignment(.leading)

            }  //close Grid
            .frame(maxWidth: .infinity, maxHeight: 200)
            .padding(.bottom, 20)

            //MARK:  2 card activity

            LazyVGrid(
                columns: Array(repeating: GridItem(spacing: 20), count: 2)
            ) {
                ForEach(homeViewModel.mockActivity, id: \.id) { activity in
                    ActivityCard(activity: activity)
                }
            }

        }
    }
}

#Preview {
    HomeView()
}
