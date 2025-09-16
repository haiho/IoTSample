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
        BaseScrollVStrack(backgroundColor: Color.orange) {
            VStack(spacing: 20) {
                //1. MARK:  notifi syndata health app
                HStack {
                    CustomText("per_request_syn_health_app", isLocalized: true)
                        .color(Color.blue)

                    Image(
                        systemName:
                            "arrow.trianglehead.2.clockwise.rotate.90.icloud"
                    ).resizable()
                        .frame(width: 40, height: 36)
                        .padding(.trailing, 20)
                        .foregroundColor(Color.blue)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .border(Color.blue, width: 1)
                .onTapGesture {
                    // request permission for read data from health app
                    homeViewModel.requestSynHealthDataToday()

                }

                //2. MARK:  info and circle chart
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
                                CustomText("\(homeViewModel.excersiceTime)")
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

                        }
                        .gridCellColumns(2)

                    }
                }
                .gridColumnAlignment(.leading)

            }  //close Grid
            .frame(maxWidth: .infinity, maxHeight: 200)

            //3. MARK:  card activity

            LazyVGrid(
                columns: Array(repeating: GridItem(spacing: 20), count: 2)
            ) {
                ForEach(homeViewModel.mockActivity, id: \.id) { activity in
                    ActivityCard(activity: activity)
                }
            }.padding(.top, 40)

        }  // for view parent : VStack
        .padding(.top, 0)
        .alert(
            "title_per_health_app".localized,
            isPresented: $homeViewModel.showPermissionAlert
        ) {
            Button("btn_open_setting".localized) {
                if let url = URL(
                    string: UIApplication.openSettingsURLString
                ) {
                    UIApplication.shared.open(url)
                }
            }
            Button("btn_cancel".localized, role: .cancel) {}
        } message: {
            Text("msg_pls_acept_per_health_app".localized)
        }

    }  //BaseScrollVStrack
}

#Preview {
    HomeView()
}
