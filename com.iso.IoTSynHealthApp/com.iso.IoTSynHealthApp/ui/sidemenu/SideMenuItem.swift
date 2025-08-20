import SwiftUI

struct SideMenuItem: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)

                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium, design: .default))

                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

