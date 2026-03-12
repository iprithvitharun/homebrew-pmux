import Foundation

/// Intercepts typed commands before they reach the shell PTY.
/// Returns nil if the command should pass through to the shell normally.
/// Returns a replacement command string if it was handled/transformed.
class CommandMiddleware {
    private let commands: [CommandHandler] = [
        FilesystemCommands(),
        GitCommands(),
        NpmCommands(),
        ClaudeCommands(),
        TabCommands(),
        HelpCommand(),
    ]

    struct CommandResult {
        let handled: Bool
        let replacement: String?    // Shell command to execute instead
        let output: String?         // Direct output (no shell needed)
        let interactive: InteractivePrompt?
    }

    struct InteractivePrompt {
        let question: String
        let handler: (String) -> String  // Takes user input, returns shell command
    }

    func process(_ input: String) -> CommandResult {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return CommandResult(handled: false, replacement: nil, output: nil, interactive: nil)
        }

        for handler in commands {
            if let result = handler.handle(trimmed) {
                return result
            }
        }

        // Not handled — pass through to shell
        return CommandResult(handled: false, replacement: nil, output: nil, interactive: nil)
    }
}

protocol CommandHandler {
    func handle(_ input: String) -> CommandMiddleware.CommandResult?
}
