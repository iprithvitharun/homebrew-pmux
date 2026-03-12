import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var terminalManager = TerminalManager()

    var body: some View {
        VStack(spacing: 0) {
            // Custom tab bar
            TabBarView()

            // Terminal content — ZStack keeps all tabs alive, only selected is visible
            ZStack {
                ForEach(appState.tabs) { tab in
                    TerminalContainerView(tab: tab)
                        .opacity(tab.id == appState.selectedTabId ? 1 : 0)
                        .allowsHitTesting(tab.id == appState.selectedTabId)
                }
            }
        }
        .background(PrithviTheme.background)
        .environmentObject(terminalManager)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("prithvi.renameTab"))) { notification in
            if let title = notification.userInfo?["title"] as? String,
               let id = appState.selectedTabId {
                appState.renameTab(id: id, newTitle: title)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .newTab)) { notification in
            let title = notification.userInfo?["title"] as? String ?? "Terminal"
            appState.addTab(title: title)
        }
        .onChange(of: appState.tabs.count) { newCount in
            // Clean up terminals for removed tabs
            let tabIds = Set(appState.tabs.map(\.id))
            // Terminal cleanup happens via TerminalManager
        }
    }
}
