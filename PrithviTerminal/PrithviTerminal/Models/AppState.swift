import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var tabs: [TerminalTab] = []
    @Published var selectedTabId: UUID?

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Start with one tab
        let firstTab = TerminalTab(title: "Terminal")
        tabs = [firstTab]
        selectedTabId = firstTab.id

        setupNotifications()
    }

    private func setupNotifications() {
        NotificationCenter.default.publisher(for: .newTab)
            .sink { [weak self] _ in self?.addTab() }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: .closeTab)
            .sink { [weak self] _ in self?.closeCurrentTab() }
            .store(in: &cancellables)
    }

    func addTab(title: String = "Terminal") {
        let tab = TerminalTab(title: title)
        tabs.append(tab)
        selectedTabId = tab.id
    }

    func closeTab(id: UUID) {
        guard tabs.count > 1 else { return } // Keep at least one tab
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            tabs.remove(at: index)
            if selectedTabId == id {
                selectedTabId = tabs[max(0, index - 1)].id
            }
        }
    }

    func closeCurrentTab() {
        if let id = selectedTabId {
            closeTab(id: id)
        }
    }

    func renameTab(id: UUID, newTitle: String) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            tabs[index].title = newTitle
        }
    }

    var selectedTab: TerminalTab? {
        tabs.first(where: { $0.id == selectedTabId })
    }
}
