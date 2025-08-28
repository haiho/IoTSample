//
//  ProcessCircleview.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 27/8/25.
//
import SwiftUI

struct ProgressCircleView: View {
    @Binding var progress: Int
    var goal: Int
    var color: Color
    var with: CGFloat = AppPadding.withProgress

    var body: some View {
        ZStack {
            // Vòng tròn nền mờ
            Circle()
                .stroke(color.opacity(0.3), lineWidth: with)

            // Vòng tròn thể hiện tiến độ
            Circle()
                .trim(from: 0, to: CGFloat(Double(progress) / Double(goal)))
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: with,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))  // Xoay để bắt đầu từ đỉnh
                .animation(.easeInOut(duration: 0.5), value: progress)
                .shadow(radius: 5)

            // Hiển thị phần trăm ở giữa
            //            Text("\(Int(Double(progress) / Double(goal) * 100))%")
            //                .font(.title)
            //                .bold()
            //                .foregroundColor(color)
        }
    }
}

#Preview {
    ProgressCircleView(
        progress: .constant(100),
        goal: 600,
        color: .red
    )
}
