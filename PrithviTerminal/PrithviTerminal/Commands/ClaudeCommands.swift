import Foundation

class ClaudeCommands: CommandHandler {
    func handle(_ input: String) -> CommandMiddleware.CommandResult? {
        if input == "claude" {
            return .init(handled: true, replacement: "claude", output: nil, interactive: nil)
        }

        if input.hasPrefix("claude ") {
            let prompt = String(input.dropFirst(7)).trimmingCharacters(in: .whitespaces)
            return .init(handled: true, replacement: "claude \(prompt)", output: nil, interactive: nil)
        }

        return nil
    }
}
