import Foundation

class FilesystemCommands: CommandHandler {
    func handle(_ input: String) -> CommandMiddleware.CommandResult? {
        if input.hasPrefix("go to ") {
            let target = String(input.dropFirst(6)).trimmingCharacters(in: .whitespaces)
            return .init(
                handled: true,
                replacement: "cd \(shellEscape(target)) && echo '  \\033[38;5;114m✓\\033[0m Now in \\033[38;5;117m'$(basename \"$PWD\")'\\033[0m'",
                output: nil,
                interactive: nil
            )
        }

        if input == "go back" {
            return .init(
                handled: true,
                replacement: "cd .. && echo '  \\033[38;5;114m✓\\033[0m Now in \\033[38;5;117m'$(basename \"$PWD\")'\\033[0m'",
                output: nil,
                interactive: nil
            )
        }

        if input == "go home" {
            return .init(
                handled: true,
                replacement: "cd ~ && echo '  \\033[38;5;114m✓\\033[0m Now in \\033[38;5;117m~\\033[0m'",
                output: nil,
                interactive: nil
            )
        }

        if input == "show files" {
            return .init(handled: true, replacement: "ls -la", output: nil, interactive: nil)
        }

        if input.hasPrefix("show files ") {
            let path = String(input.dropFirst(11)).trimmingCharacters(in: .whitespaces)
            return .init(handled: true, replacement: "ls -la \(shellEscape(path))", output: nil, interactive: nil)
        }

        if input.hasPrefix("open ") {
            let file = String(input.dropFirst(5)).trimmingCharacters(in: .whitespaces)
            return .init(handled: true, replacement: "cat \(shellEscape(file))", output: nil, interactive: nil)
        }

        if input.hasPrefix("new folder ") {
            let name = String(input.dropFirst(11)).trimmingCharacters(in: .whitespaces)
            return .init(
                handled: true,
                replacement: "mkdir -p \(shellEscape(name)) && echo '  \\033[38;5;114m✓\\033[0m Created folder \\033[38;5;117m\(name)\\033[0m'",
                output: nil,
                interactive: nil
            )
        }

        if input.hasPrefix("new file ") {
            let name = String(input.dropFirst(9)).trimmingCharacters(in: .whitespaces)
            return .init(
                handled: true,
                replacement: "touch \(shellEscape(name)) && echo '  \\033[38;5;114m✓\\033[0m Created file \\033[38;5;117m\(name)\\033[0m'",
                output: nil,
                interactive: nil
            )
        }

        if input == "where am i" {
            return .init(
                handled: true,
                replacement: "echo '  \\033[38;5;111m→\\033[0m \\033[38;5;117m'$PWD'\\033[0m'",
                output: nil,
                interactive: nil
            )
        }

        return nil
    }

    private func shellEscape(_ str: String) -> String {
        return "'" + str.replacingOccurrences(of: "'", with: "'\\''") + "'"
    }
}
