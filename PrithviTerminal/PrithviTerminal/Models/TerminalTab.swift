import Foundation

struct TerminalTab: Identifiable {
    let id = UUID()
    var title: String
    var splitPanes: [SplitPane]

    init(title: String = "Terminal") {
        self.title = title
        self.splitPanes = [SplitPane()]
    }
}

struct SplitPane: Identifiable {
    let id = UUID()
    var direction: SplitDirection?

    enum SplitDirection {
        case horizontal
        case vertical
    }
}
