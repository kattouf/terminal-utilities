import Foundation

public final class SizeObserver {
    private var signalHandler: DispatchSourceSignal?
    private(set) var size = Terminal.size()
    private var sizeChangeHandlers = [(Size) -> Void]()

    private init() {}

    public static func observe() -> SizeObserver {
        let observer = SizeObserver()
        observer.setupSignalHandler()
        return observer
    }

    public func addSizeChangeHandler(_ handler: @escaping (Size) -> Void) {
        self.sizeChangeHandlers.append(handler)
    }

    private func setupSignalHandler() {
        let signalHandler = DispatchSource.makeSignalSource(signal: SIGWINCH)
        signal(SIGWINCH, SIG_IGN)

        signalHandler.setEventHandler { [weak self] in
            guard let self else {
                return
            }
            let newSize = Terminal.size()
            guard newSize != self.size else {
                return
            }
            self.size = newSize
            self.sizeChangeHandlers.forEach { $0(newSize) }
        }
        signalHandler.resume()

        self.signalHandler = signalHandler
    }
}
