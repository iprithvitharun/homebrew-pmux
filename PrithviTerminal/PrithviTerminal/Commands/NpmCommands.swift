import Foundation

class NpmCommands: CommandHandler {
    func handle(_ input: String) -> CommandMiddleware.CommandResult? {
        switch input {
        case "npm start":
            return .init(handled: true, replacement: "npm start", output: nil, interactive: nil)

        case "npm dev":
            return .init(handled: true, replacement: "npm run dev", output: nil, interactive: nil)

        case "npm build":
            return .init(handled: true, replacement: "npm run build", output: nil, interactive: nil)

        case "npm test":
            return .init(handled: true, replacement: "npm test", output: nil, interactive: nil)

        case "npm install":
            return .init(handled: true, replacement: "npm install", output: nil, interactive: nil)

        default:
            if input.hasPrefix("npm install ") {
                let pkg = String(input.dropFirst(12)).trimmingCharacters(in: .whitespaces)
                return .init(handled: true, replacement: "npm install \(pkg)", output: nil, interactive: nil)
            }

            if input.hasPrefix("npm remove ") {
                let pkg = String(input.dropFirst(11)).trimmingCharacters(in: .whitespaces)
                return .init(handled: true, replacement: "npm uninstall \(pkg)", output: nil, interactive: nil)
            }

            if input.hasPrefix("npm run ") {
                let script = String(input.dropFirst(8)).trimmingCharacters(in: .whitespaces)
                return .init(handled: true, replacement: "npm run \(script)", output: nil, interactive: nil)
            }

            return nil
        }
    }
}
