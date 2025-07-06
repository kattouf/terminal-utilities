import ArgumentParser
import TerminalUtilities

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

@main
struct TerminalUtilitiesCLI: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(subcommands: [
            SizeCommand.self,
            AnimateCommand.self
        ])
    }

    mutating func run() async throws {}
}

struct SizeCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "size")
    }

    mutating func run() {
        print("Current window dimensions:", Terminal.size(), separator: "\n")
    }
}

struct AnimateCommand: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "animate",
            abstract: "Perform a small animation, demonstrating clearing characters and hiding the cursor"
        )
    }

    mutating func run() async throws {
        Terminal.showCursor(false)
        defer { Terminal.showCursor(true) }

        print("\n")

        var currentFrame = 0

        while currentFrame <= 40 {
            let toPrint = String(repeating: "_", count: currentFrame) + "⚽"
            let spaces = String(repeating: "_", count: 40 - currentFrame) + "🥅"
            print(toPrint + spaces, terminator: "")
            fflush(stdout)
            try await Task.sleep(for: .seconds(0.04))
            if currentFrame == 40 { break }
            Terminal.eraseChars(toPrint.count + spaces.count + 2)
            currentFrame += 1
        }

        print("\n")
        print("🎉_________________GOAL!_________________🎉")
        print("\n")
    }
}
