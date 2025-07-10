import ArgumentParser
import Foundation
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
            SizeObserverCommand.self,
            AnimateCommand.self,
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

struct SizeObserverCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "size-observer")
    }

    mutating func run() {
        print("Running size observer, change the size of your terminal window to see the output change")
        print("Press Ctrl+C to stop")

        func currentSizeMessage(_ size: Size) -> String {
            "Current window dimensions: \(size)"
        }

        print(currentSizeMessage(Terminal.size()))
        Terminal.cursorUp()

        let sizeObserver = SizeObserver()
        var lastPrinterMessageLength: Int?
        sizeObserver.observe { size in
            if let lastPrinterMessageLength {
                Terminal.eraseChars(lastPrinterMessageLength)
            }
            let toPrint = currentSizeMessage(size)
            lastPrinterMessageLength = toPrint.count
            print(toPrint, terminator: "")
            fflush(stdout)
        }

        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in }
        RunLoop.current.run()
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

        Terminal.onInterruptionExit {
            Terminal.showCursor(true)
        }

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
