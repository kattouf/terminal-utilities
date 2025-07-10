import Foundation

public final class SizeObserver {
    private var signalHandler: DispatchSourceSignal?
    private(set) var size = Terminal.size()
    private var sizeDidChange: ((Size) -> Void)?

    public init() {}

    public func observe(sizeDidChange: @escaping (Size) -> Void) {
        setupSignalHandler()
        self.sizeDidChange = sizeDidChange
    }

    private func setupSignalHandler() {
        let sigwinch = SIGWINCH

        let signalHandler = DispatchSource.makeSignalSource(signal: sigwinch)
        signal(sigwinch, SIG_IGN)

        signalHandler.setEventHandler { [weak self] in
            guard let self else {
                return
            }
            let newSize = Terminal.size()
            guard newSize != self.size else {
                return
            }
            self.size = newSize
            self.sizeDidChange?(newSize)
        }
        signalHandler.resume()

        self.signalHandler = signalHandler
    }
}
