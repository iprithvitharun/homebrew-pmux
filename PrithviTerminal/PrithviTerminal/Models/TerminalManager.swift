import Foundation
import AppKit

/// Keeps terminal view instances alive across tab switches.
/// SwiftUI would destroy/recreate NSViews on tab change — this prevents that.
class TerminalManager: ObservableObject {
    private var terminals: [UUID: PrithviTerminalView] = [:]

    func terminalView(for tabId: UUID) -> PrithviTerminalView {
        if let existing = terminals[tabId] {
            return existing
        }
        let view = PrithviTerminalView()
        view.setupTerminal()
        terminals[tabId] = view
        return view
    }

    func removeTerminal(for tabId: UUID) {
        terminals.removeValue(forKey: tabId)
    }

    func hasTerminal(for tabId: UUID) -> Bool {
        terminals[tabId] != nil
    }
}
