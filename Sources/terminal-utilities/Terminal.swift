import Foundation

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

public enum Terminal {
    public static func size() -> Size {
        var size = winsize()
        guard ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size) == 0,
              size.ws_col > 0, size.ws_row > 0 else {
            return .zero
        }

        return Size(columns: size.ws_col, rows: size.ws_row)
    }

    public static func eraseChars(_ length: Int) {
        guard length > 0 else { return }

        // Move cursor left by the number of characters we previously drew
        print("\u{001B}[\(length)D", terminator: "")
    }

    public static func eraseScreen() {
        print("\u{001B}[2J", terminator: "")
    }

    public static func cursorUp(_ count: Int = 1) {
        print("\u{1B}[\(count)A", terminator: "")
    }

    public static func showCursor(_ show: Bool) {
        if show {
            print("\u{001B}[?25h", terminator: "")
        } else {
            print("\u{001B}[?25l", terminator: "")
        }
    }

    private nonisolated(unsafe) static let sizeObserver = SizeObserver.observe()
    public static func onSizeChange(_ handler: @escaping (Size) -> Void) {
        sizeObserver.addSizeChangeHandler(handler)
    }

    private nonisolated(unsafe) static let interruptionObserver = InterruptionObserver.observe()
    public static func onInterruptionExit(_ handler: @escaping () -> Void) {
        interruptionObserver.addInterruptionHandler(handler)
    }
}
