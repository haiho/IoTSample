import SwiftUI

struct MainView: View {
    @State private var showSideMenu = false
    @State private var selectedScreen: MenuScreen = .home
    @StateObject var navManager = MainNavigationManager()

    var body: some View {
        let isRoot = navManager.path.isEmpty  // 👈 kiểm tra đang ở màn chính

        return NavigationStack(path: $navManager.path) {
            ZStack {
                // Nội dung chính của màn hình
                Group {
                    switch selectedScreen {
                    case .home:
                        HomeView()
                    case .account:
                        SettingsView()
                    case .settings:
                        SettingsView()
                    }
                }
                .customNavigationBar(
                    title: titleForScreen(selectedScreen)
                )
                .navigationBarItems(
                    leading: isRoot
                        ? AnyView(
                            Button(action: {
                                withAnimation {
                                    self.showSideMenu.toggle()
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .imageScale(.large)
                            }
                        ) : AnyView(EmptyView())  // 👈 Ẩn menu button nếu không ở root
                )
            }
            .navigationDestination(for: MainScreen.self) { route in
                switch route {
                case .carDetail(let activity):
                    ActivityCardDetail(activity: activity)
                case .viewAllData(let activity):
                    ActivityAllDataView(activity: activity)
                }
            }
        }
        .onChange(of: navManager.path) { oldPath, newPath in
            withAnimation {
                // Đóng menu khi push
                if !newPath.isEmpty {
                    showSideMenu = false
                }
            }
        }
        .environmentObject(navManager)
        .sideMenu(
            isShowing: Binding(
                get: {
                    // ✅ Chỉ cho mở menu nếu đang ở root
                    isRoot && showSideMenu
                },
                set: { newValue in
                    showSideMenu = newValue
                }
            )
        ) {
            SideMenuContent(isShowing: $showSideMenu) { screen in
                withAnimation {
                    self.selectedScreen = screen
                    self.showSideMenu = false  // ✅ Tắt menu sau khi chọn
                }
            }
        }
    }

    private func titleForScreen(_ screen: MenuScreen) -> LocalizedStringKey {
        switch screen {
        case .home: return "title_home_screen"
        case .account: return "Tài khoản"
        case .settings: return "title_settings_screen"
        }
    }
}
